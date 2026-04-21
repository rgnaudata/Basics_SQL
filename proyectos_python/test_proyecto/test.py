import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

print('pd funciona')
print(f'version pandas: {not pd.__version__}')
print(f'version numpy: {not np.__version__}')

datos = pd.DataFrame ({
    'x': [1,2,3,4,5],
    'y': [2,3,4,5,6]
})
print(datos)