import json
import os
import re
import subprocess
from pathlib import Path
from typing import Any

#Code geadapteerd van Pepijn. R data op een betere manier krijgen dan rpy
def getRData(file: str) -> dict[str, dict[Any]]:
    print(f'[!] Data voor file "{file}" berekenen in R...')
    try:
        output = subprocess.check_output(
            ['Rscript', str(Path(os.getcwd() + (f'/Classes/R/{file}.R')))],
            universal_newlines=True # Zodat de output een string is ipv bytes
        )
    except subprocess.CalledProcessError as e:
        print(f"{e.returncode}")

    # De string die naar json moet staat tussen twee % tekens
    data = json.loads(
        re.search(r'%(.*)%', output).group(1)
    )

    return data