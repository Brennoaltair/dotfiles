"""Isolated checks: never install apps or change macOS preferences."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent


def run(shell, code, home):
    return subprocess.run(
        [shell, '-c', code], env={**os.environ, 'HOME': str(home)},
        capture_output=True, text=True,
    )


with tempfile.TemporaryDirectory(prefix='dotfiles-test-') as directory:
    home = Path(directory)
    setup = (ROOT / 'install.sh').read_text().split('# ── Banner')[0]
    extract = (ROOT / '.zshrc').read_text().split('extract() {')[1].split('\n}\n')[0]
    result = run('zsh', '7zz() { [[ "$1" == x && "$2" == test.7z ]]; }\n'
                 + 'extract() {' + extract + '\n}\nextract test.7z', home)
    assert result.returncode == 0, result.stderr
    result = run('zsh', 'extract() {' + extract + '\n}\nextract unknown.format', home)
    assert result.returncode != 0 and 'unknown.format' in result.stderr, result.stderr

    link_home = home / 'link'
    (link_home / '.config/nvim').mkdir(parents=True)
    (link_home / '.config/nvim/init.lua').write_text('old')
    code = setup + f'\nDOTFILES={str(ROOT)!r}\nlink .config/nvim .config/nvim\n'
    result = run('bash', code, link_home)
    assert result.returncode == 0, result.stderr
    backups = list((link_home / '.config').glob('nvim.bak.*'))
    assert len(backups) == 1 and (backups[0] / 'init.lua').read_text() == 'old'
    assert (link_home / '.config/nvim').resolve() == ROOT / '.config/nvim'

    check_root = home / 'syntax'
    (check_root / 'scripts').mkdir(parents=True)
    shutil.copy(ROOT / 'scripts/check.sh', check_root / 'scripts/check.sh')
    files = ('install.sh', 'macos-defaults.sh', '.zprofile', '.zshrc', 'scripts/extra.sh')
    for name in files:
        (check_root / name).write_text(':\n')
    for name in ('macos-defaults.sh', '.zshrc', 'scripts/extra.sh'):
        (check_root / name).write_text('if then\n')
        result = subprocess.run(['bash', str(check_root / 'scripts/check.sh')],
                                capture_output=True, text=True)
        assert result.returncode != 0 and name in result.stderr, result.stderr
        (check_root / name).write_text(':\n')

print('Regression checks passed.')
