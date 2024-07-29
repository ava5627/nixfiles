
import importlib

c = get_config()  # NOQA
# The name or class of a Pygments style to use for syntax
#          highlighting. To see available styles, run `pygmentize -L styles`.
#  Default: traitlets.Undefined
c.TerminalInteractiveShell.highlighting_style = 'monokai'
try:
    # sources:
    # https://github.com/ipython/ipython/issues/13446
    # https://github.com/ipython/ipython/issues/13486
    # https://github.com/ipython/ipython/pull/13756
    # https://github.com/ipython/ipython/pull/14476
    from IPython.core import ultratb
    ultratb.VerboseTB._tb_highlight = "bg:ansired ansiblack"
    ultratb.VerboseTB._tb_highlight_style = "monokai"
except Exception:
    print("Error patching background color for tracebacks, they'll be the ugly default instead")
# Use 24bit colors instead of 256 colors in prompt highlighting.
#          If your terminal supports true color, the following command should
#          print ``TRUECOLOR`` in orange::
#
#              printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
#  Default: False
c.TerminalInteractiveShell.true_color = True

# Enable rich if installed
if importlib.util.find_spec('rich'):
    c.InteractiveShellApp.extensions.append('rich')

# Enable autoreload
c.InteractiveShellApp.extensions.append('autoreload')
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
