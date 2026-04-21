import pandas as pd
from matplotlib import pyplot as plt

#import numpy as np
#import matplotlib.pyplot as plt

lettuce=pd.read_csv('/home/arnau/Descargas/lettuce1.csv', encoding='ISO-8859-1')

## Información general del dataset
print(lettuce.head())
print(lettuce.info())
print(lettuce.describe())
print(lettuce.columns)

# creamos un indice con la columna Plant_ID
lettuce_i = lettuce.set_index('Plant_ID')
print(lettuce_i.head())


#id_1 = lettuce[lettuce['Plant_ID'] == 1]
#id_2 = lettuce[lettuce['Plant_ID'] == 2]
#print(id_1.head())
#id_1.plot(x='Growth_Days', y='Tem', kind='line', color='red')
#id_2.plot(x='Growth_Days', y='Tem', kind='line', color='blue')
#plt.show()


######TEMPERATURA#######

#creamos subset con temperatura y dias crecimiento
id_t = lettuce_i[['Tem', 'Growth_Days']]
print(id_t.head())

#agrupamos por Plant_ID y encontramos la tem media
gr_av_id_t = lettuce.groupby('Plant_ID')['Tem'].mean()
print(gr_av_id_t.head())

#agrupamos por Plant_ID y encontramos la tem min, max, media y st dsv
gr_m_id_t = lettuce.groupby('Plant_ID')['Tem'].agg(['min', 'max', 'mean', 'median', 'std'])
print(gr_m_id_t.head(25))


