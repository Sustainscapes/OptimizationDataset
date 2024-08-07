Optimización de biodiversidad para Dinamarca (Biodiversity optimization
for Denmark)
================

- [1 Español](#1-español)
  - [1.1 Resumen del problema](#11-resumen-del-problema)
    - [1.1.1 Modelo de optimización para la planificación de la
      conservación en
      Dinamarca](#111-modelo-de-optimización-para-la-planificación-de-la-conservación-en-dinamarca)
- [2 English](#2-english)
  - [2.1 Problem summary](#21-problem-summary)
    - [2.1.1 Optimization model for conservation planning in
      Denmark](#211-optimization-model-for-conservation-planning-in-denmark)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# 1 Español

## 1.1 Resumen del problema

En respuesta a la nueva ley europea de restauración, que exige la
recuperación del 20% de la naturaleza degradada, nuestro proyecto se
centra en optimizar dos aspectos clave: identificar las áreas
prioritarias para la restauración en Europa y determinar los tipos de
ecosistemas que deben ser restaurados en cada área. Dinamarca se
utilizará como caso de estudio.

Nuestra institución ha desarrollado modelos que priorizan la
conectividad ecológica, la conservación de la biodiversidad y la
maximización de los servicios ecosistémicos. Sin embargo, reconocemos
que estos modelos pueden ser perfeccionados. Por ello, buscamos mejorar
la eficiencia y el alcance de nuestro algoritmo de optimización mediante
la aplicación de técnicas avanzadas de análisis espacial y el desarrollo
de enfoques innovadores para la restauración ecológica.

### 1.1.1 Modelo de optimización para la planificación de la conservación en Dinamarca

Este documento ofrece una descripción general del modelo de optimización
diseñado para mejorar la conservación de la biodiversidad en Dinamarca.
El modelo identifica las áreas óptimas para convertir tierras agrícolas
en áreas naturales protegidas, teniendo en cuenta el potencial de
biodiversidad, la conectividad y los objetivos de conservación
específicos.

#### 1.1.1.1 Descripción del problema

El objetivo es proteger el 30% de la naturaleza en Dinamarca optimizando
la selección de áreas agrícolas para mejorar la biodiversidad.
Actualmente, el 16% de la tierra está protegida y se necesita
seleccionar un 14% adicional de áreas agrícolas, considerando que el 60%
del territorio danés está destinado a la agricultura. La optimización se
basa en el potencial de biodiversidad, evaluado según la idoneidad del
hábitat y los grupos de especies esperados para ocho tipos de
naturaleza, organizados en tres ejes de transformación:

- Bosque-Seco-Rico
- Bosque-Seco-Pobre
- Bosque-Húmedo-Rico
- Bosque-Húmedo-Pobre
- Abierto-Seco-Rico
- Abierto-Seco-Pobre
- Abierto-Húmedo-Rico
- Abierto-Húmedo-Pobre

Estos tipos de ambientes se definen por tres factores principales: la
transformación en bosque o abierto, determinada por la gestión; seco o
húmedo, que depende principalmente de la topografía; y rico o pobre,
relacionado con los nutrientes en el suelo. El objetivo es maximizar la
biodiversidad, garantizar la conectividad espacial y cumplir con los
objetivos específicos de uso de suelo.

Dentro de las restricciones de uso del suelo, se incluyen 250,000
hectáreas de nuevos bosques prometidas por el nuevo gobierno, que pueden
ser húmedos o secos, y 140,000 hectáreas de áreas húmedas, que pueden
ser abiertas o bosques.

#### 1.1.1.2 Descripción del modelo en AMPL

El modelo AMPL define conjuntos, parámetros y variables para capturar la
estructura y las restricciones del problema. A continuación, se incluye
un desglose detallado:

##### 1.1.1.2.1 Sets and Parameters

- `Cells`: Set de celdas agrícolas.
- `Landuses`: Set de usos de suelo.
- `ForestLanduses`: Subset de usos de suelo que son de bosque.
- `WetLanduses`: Subset de usos de suelo que son de humedos.
- `E`: Set de celdas adyacentes (i, j) indicando contiguidad potencial.
- `Existingnature[Landuses, Cells]`: Indica si una celda es actualmente
  de un tipo especifico de naturaleza.
- `Richness[Landuses, Cells]`: Valor de biodiversidad (riqueza de
  especies) para cada celda y tipo de uso de suelo.
- `PhyloDiversity[Landuses, Cells]`: Diversidad Filogenetica para cada
  uso de suelo y celda.
- `TransitionCost[Landuses, Cells]`: Costo de transformar una celda
  agricola a un tipo especifico de uso de suelo.
- `CanChange[Cells]`: Indica si una celda puede ser cambiada (Celdas
  agricolas).
- `b`: Restricción de presupuesto para el costo de transiciones.
- `MinFor`: Area mínima requerida para nuevos bosques.
- `MinWet`: Area mínima requerida para nuevas areas humedas.
- `MinLan`: Area mínima requerida para cada uso de suelo excepto
  agricultura.
- `SpatialContiguityBonus`: Bono por crear areas contiguas del mismo uso
  de suelo.

##### 1.1.1.2.2 Variables

- `LanduseDecision[l in Landuses, c in Cells]`: Variable binaria
  indicando si el uso de suelo `l` es seleccionado para la celda `c`.
- `Contiguity[l in Landuses, (i,j) in E]`: Variable binaria indicando si
  las celdas `i` y `j` son contiguas para el uso de suelo `l`.

##### 1.1.1.2.3 Función objetivo

El objetivo es maximizar el Índice de Conservación, incorporando
métricas de biodiversidad y contigüidad espacial:

![\\
\begin{aligned}
\text{maximize } & \sum\_{l \in \text{Landuses}, c \in \text{Cells}} \text{LanduseDecision}\[l,c\] \times \text{Richness}\[l,c\] \times \text{PhyloDiversity}\[l,c\] \times \text{CanChange}\[c\] \\
& + \text{SpatialContiguityBonus} \times \sum\_{(i,j) \in E, l \in \text{Landuses}} \left( \text{Contiguity}\[l,i,j\] \times \text{CanChange}\[i\] \times \text{CanChange}\[j\] + \text{Existingnature}\[l,i\] \times \text{LanduseDecision}\[l,j\] \times \text{CanChange}\[j\] \right)
\end{aligned}
\\](https://latex.codecogs.com/png.latex?%5C%5B%0A%5Cbegin%7Baligned%7D%0A%5Ctext%7Bmaximize%20%7D%20%26%20%5Csum_%7Bl%20%5Cin%20%5Ctext%7BLanduses%7D%2C%20c%20%5Cin%20%5Ctext%7BCells%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Ctimes%20%5Ctext%7BRichness%7D%5Bl%2Cc%5D%20%5Ctimes%20%5Ctext%7BPhyloDiversity%7D%5Bl%2Cc%5D%20%5Ctimes%20%5Ctext%7BCanChange%7D%5Bc%5D%20%5C%5C%0A%26%20%2B%20%5Ctext%7BSpatialContiguityBonus%7D%20%5Ctimes%20%5Csum_%7B%28i%2Cj%29%20%5Cin%20E%2C%20l%20%5Cin%20%5Ctext%7BLanduses%7D%7D%20%5Cleft%28%20%5Ctext%7BContiguity%7D%5Bl%2Ci%2Cj%5D%20%5Ctimes%20%5Ctext%7BCanChange%7D%5Bi%5D%20%5Ctimes%20%5Ctext%7BCanChange%7D%5Bj%5D%20%2B%20%5Ctext%7BExistingnature%7D%5Bl%2Ci%5D%20%5Ctimes%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cj%5D%20%5Ctimes%20%5Ctext%7BCanChange%7D%5Bj%5D%20%5Cright%29%0A%5Cend%7Baligned%7D%0A%5C%5D "\[
\begin{aligned}
\text{maximize } & \sum_{l \in \text{Landuses}, c \in \text{Cells}} \text{LanduseDecision}[l,c] \times \text{Richness}[l,c] \times \text{PhyloDiversity}[l,c] \times \text{CanChange}[c] \\
& + \text{SpatialContiguityBonus} \times \sum_{(i,j) \in E, l \in \text{Landuses}} \left( \text{Contiguity}[l,i,j] \times \text{CanChange}[i] \times \text{CanChange}[j] + \text{Existingnature}[l,i] \times \text{LanduseDecision}[l,j] \times \text{CanChange}[j] \right)
\end{aligned}
\]")

##### 1.1.1.2.4 Restricciones

1.**Uso proporcional**: garantiza solo un uso de suelo por celda.

![\\
    \sum\_{l \in \text{Landuses}} \text{LanduseDecision}\[l,c\] \leq 1 \quad \forall c \in \text{Cells}
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Csum_%7Bl%20%5Cin%20%5Ctext%7BLanduses%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Cleq%201%20%5Cquad%20%5Cforall%20c%20%5Cin%20%5Ctext%7BCells%7D%0A%20%20%20%20%5C%5D "\[
    \sum_{l \in \text{Landuses}} \text{LanduseDecision}[l,c] \leq 1 \quad \forall c \in \text{Cells}
    \]")

2.  **Requisito de area mínimo de uso de suelo**: Garantiza un área
    mínima para cada tipo de uso de suelo (excluyendo la agricultura).

![\\
    \sum\_{c \in \text{Cells}} \text{LanduseDecision}\[l,c\] \geq \text{MinLan} \quad \forall l \in \text{Landuses} \setminus \\ \text{'Ag'} \\
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Csum_%7Bc%20%5Cin%20%5Ctext%7BCells%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Cgeq%20%5Ctext%7BMinLan%7D%20%5Cquad%20%5Cforall%20l%20%5Cin%20%5Ctext%7BLanduses%7D%20%5Csetminus%20%5C%7B%20%5Ctext%7B%27Ag%27%7D%20%5C%7D%0A%20%20%20%20%5C%5D "\[
    \sum_{c \in \text{Cells}} \text{LanduseDecision}[l,c] \geq \text{MinLan} \quad \forall l \in \text{Landuses} \setminus \{ \text{'Ag'} \}
    \]")

3.  **Sin Agricultura**: Evita la selección del uso de suelo agrícola.

![\\
    \text{LanduseDecision}\[\text{'Ag'}, c\] = 0 \quad \forall c \in \text{Cells}
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Ctext%7BLanduseDecision%7D%5B%5Ctext%7B%27Ag%27%7D%2C%20c%5D%20%3D%200%20%5Cquad%20%5Cforall%20c%20%5Cin%20%5Ctext%7BCells%7D%0A%20%20%20%20%5C%5D "\[
    \text{LanduseDecision}[\text{'Ag'}, c] = 0 \quad \forall c \in \text{Cells}
    \]")

4.  **Área Forestal Mínima**: Garantiza un área mínima para usos de
    tierras de bosque.

![\\
    \sum\_{c \in \text{Cells}, l \in \text{ForestLanduses}} \text{LanduseDecision}\[l,c\] \geq \text{MinFor}
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Csum_%7Bc%20%5Cin%20%5Ctext%7BCells%7D%2C%20l%20%5Cin%20%5Ctext%7BForestLanduses%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Cgeq%20%5Ctext%7BMinFor%7D%0A%20%20%20%20%5C%5D "\[
    \sum_{c \in \text{Cells}, l \in \text{ForestLanduses}} \text{LanduseDecision}[l,c] \geq \text{MinFor}
    \]")

5.  **Área mínima de humedal**: Garantiza un área mínima para usos de
    humedales.

![\\
    \sum\_{c \in \text{Cells}, l \in \text{WetLanduses}} \text{LanduseDecision}\[l,c\] \geq \text{MinWet}
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Csum_%7Bc%20%5Cin%20%5Ctext%7BCells%7D%2C%20l%20%5Cin%20%5Ctext%7BWetLanduses%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Cgeq%20%5Ctext%7BMinWet%7D%0A%20%20%20%20%5C%5D "\[
    \sum_{c \in \text{Cells}, l \in \text{WetLanduses}} \text{LanduseDecision}[l,c] \geq \text{MinWet}
    \]")

6.  **Restricción presupuestaria**: limita el costo total del
    presupuesto de transiciones.

![\\
    \sum\_{l \in \text{Landuses}, c \in \text{Cells}} \text{LanduseDecision}\[l,c\] \times \text{TransitionCost}\[l,c\] = b
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Csum_%7Bl%20%5Cin%20%5Ctext%7BLanduses%7D%2C%20c%20%5Cin%20%5Ctext%7BCells%7D%7D%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cc%5D%20%5Ctimes%20%5Ctext%7BTransitionCost%7D%5Bl%2Cc%5D%20%3D%20b%0A%20%20%20%20%5C%5D "\[
    \sum_{l \in \text{Landuses}, c \in \text{Cells}} \text{LanduseDecision}[l,c] \times \text{TransitionCost}[l,c] = b
    \]")

7.  **Definir contigüidad**: define relaciones de contigüidad.

![\\
    \begin{aligned}
    \text{Contiguity}\[l,i,j\] &\leq \text{LanduseDecision}\[l,i\] \quad \forall l \in \text{Landuses}, (i,j) \in E \\
    \text{Contiguity}\[l,i,j\] &\leq \text{LanduseDecision}\[l,j\] \quad \forall l \in \text{Landuses}, (i,j) \in E \\
    \text{Contiguity}\[l,i,j\] &\geq \text{LanduseDecision}\[l,i\] + \text{LanduseDecision}\[l,j\] - 1 \quad \forall l \in \text{Landuses}, (i,j) \in E
    \end{aligned}
    \\](https://latex.codecogs.com/png.latex?%5C%5B%0A%20%20%20%20%5Cbegin%7Baligned%7D%0A%20%20%20%20%5Ctext%7BContiguity%7D%5Bl%2Ci%2Cj%5D%20%26%5Cleq%20%5Ctext%7BLanduseDecision%7D%5Bl%2Ci%5D%20%5Cquad%20%5Cforall%20l%20%5Cin%20%5Ctext%7BLanduses%7D%2C%20%28i%2Cj%29%20%5Cin%20E%20%5C%5C%0A%20%20%20%20%5Ctext%7BContiguity%7D%5Bl%2Ci%2Cj%5D%20%26%5Cleq%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cj%5D%20%5Cquad%20%5Cforall%20l%20%5Cin%20%5Ctext%7BLanduses%7D%2C%20%28i%2Cj%29%20%5Cin%20E%20%5C%5C%0A%20%20%20%20%5Ctext%7BContiguity%7D%5Bl%2Ci%2Cj%5D%20%26%5Cgeq%20%5Ctext%7BLanduseDecision%7D%5Bl%2Ci%5D%20%2B%20%5Ctext%7BLanduseDecision%7D%5Bl%2Cj%5D%20-%201%20%5Cquad%20%5Cforall%20l%20%5Cin%20%5Ctext%7BLanduses%7D%2C%20%28i%2Cj%29%20%5Cin%20E%0A%20%20%20%20%5Cend%7Baligned%7D%0A%20%20%20%20%5C%5D "\[
    \begin{aligned}
    \text{Contiguity}[l,i,j] &\leq \text{LanduseDecision}[l,i] \quad \forall l \in \text{Landuses}, (i,j) \in E \\
    \text{Contiguity}[l,i,j] &\leq \text{LanduseDecision}[l,j] \quad \forall l \in \text{Landuses}, (i,j) \in E \\
    \text{Contiguity}[l,i,j] &\geq \text{LanduseDecision}[l,i] + \text{LanduseDecision}[l,j] - 1 \quad \forall l \in \text{Landuses}, (i,j) \in E
    \end{aligned}
    \]")

#### 1.1.1.3 Resumen

Este modelo captura la complejidad de la selección de tierras agrícolas
para la conservación de la biodiversidad, incorporando múltiples
factores ecológicos y económicos. El uso de variables binarias y
restricciones garantiza una solución factible y práctica que se alinea
con los objetivos de conservación de Dinamarca.

# 2 English

## 2.1 Problem summary

In response to the new European restoration law, which requires the
recovery of 20% of degraded nature, our project focuses on optimizing
two key aspects: identifying priority areas for restoration in Europe
and determining the types of ecosystems that should be restored in each
area. Denmark will be used as a case study.

Our institution has developed models that prioritize ecological
connectivity, biodiversity conservation, and maximization of ecosystem
services. However, we recognize that these models can be refined.
Therefore, we seek to improve the efficiency and scope of our
optimization algorithm by applying advanced spatial analysis techniques
and developing innovative approaches to ecological restoration.

### 2.1.1 Optimization model for conservation planning in Denmark

This paper provides an overview of the optimization model designed to
improve biodiversity conservation in Denmark. The model identifies
optimal areas for converting agricultural land into protected natural
areas, taking into account biodiversity potential, connectivity, and
specific conservation objectives.

#### 2.1.1.1 Problem description

The aim is to protect 30% of nature in Denmark by optimising the
selection of agricultural areas to enhance biodiversity. Currently, 16%
of the land is protected and an additional 14% of agricultural areas
need to be selected, considering that 60% of the Danish territory is
intended for agriculture. The optimisation is based on biodiversity
potential, assessed according to habitat suitability and expected
species groups for eight nature types, organised in three transformation
axes:

- Forest-Dry-Rich
- Forest-Dry-Poor
- Forest-Wet-Rich
- Forest-Wet-Poor
- Open-Dry-Rich
- Open-Dry-Poor
- Open-Wet-Rich
- Open-Wet-Poor
