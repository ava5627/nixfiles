import importlib
from IPython.core import ultratb

c = get_config()  # NOQA
c.InteractiveShell.colors = "linux"

ultratb.VerboseTB.tb_highlight_style = "monokai"
ultratb.VerboseTB.tb_highlight = "bg:ansired ansiblack"

c.TerminalInteractiveShell.true_color = True

c.InteractiveShellApp.extensions.append("autoreload")
c.InteractiveShellApp.exec_lines = ["%autoreload 2"]
if importlib.util.find_spec('rich'):
    c.InteractiveShellApp.extensions.append('rich')

c.TerminalInteractiveShell.shortcuts = [
    {
        "new_keys": ["c-q"],
        "command": "IPython:shortcuts.reset_buffer",
        "new_filter": "default_buffer_focused",
        "create": True,
    },
    {
        "new_keys": ["escape", "f"],
        "command": "IPython:auto_suggest.accept_token",
        "new_filter": "default_buffer_focused",
        "create": True,
    },
    {
        "new_keys": ["escape", "w"],
        "command": "prompt_toolkit:named_commands.backward_kill_word",
        "new_filter": "default_buffer_focused",
        "create": True,
    },
    {
        "new_keys": ["escape", "k"],
        "command": "IPython:auto_suggest.swap_autosuggestion_up",
        "new_filter": "default_buffer_focused",
        "create": True,
    },
    {
        "new_keys": ["escape", "j"],
        "command": "IPython:auto_suggest.swap_autosuggestion_down",
        "new_filter": "default_buffer_focused",
        "create": True,
    },
]
