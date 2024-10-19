import sys

from rich.console import Console

if __name__ == "__main__":
    TEMPLATE = ":{symbol_1}: {message} :{symbol_2}:"
    message = " ".join(sys.argv[1:])
    message = TEMPLATE.format(
        symbol_1="white_check_mark",
        message=message,
        symbol_2="white_check_mark",
    )
    Console().print(message)
