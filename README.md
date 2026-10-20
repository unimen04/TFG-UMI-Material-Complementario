# TFG-UMI-Material-Complementario · Códigos MATLAB

Scripts de MATLAB del Trabajo Fin de Grado *Diseño de circuitos desfasadores reflectivos de Radio Frecuencia basados en cargas reactivas* (Unai Mendoza Izquierdo, Escuela Politécnica Superior, Universidad Autónoma de Madrid, 2026).

El informe de caracterización del FR-4 está en la rama `<ayudas-investigacion>` de este mismo repositorio.

## Contenido

| Script | Sección del TFG | Descripción |
|---|---|---|
| `SMV_1236_079LF_ideal.m` | 3.2 | Modelo ideal del varactor SMV-1236-079LF (solo capacidad de unión $`C_J(V_R)`$) y fase del coeficiente de reflexión resultante. || `SMV_1236_079LF_real.m` | 3.3 | Modelo del varactor con sus parásitos ($C_{par}$, $L_{par}$, $R_{par}$), impedancia $Z_{var}(V_R)$ y coeficiente de reflexión. |
| `Optimizador_Xadd.m` | 3.4, 3.5 y 4.1.4 | Barrido de la reactancia $X_{add}$ en paralelo con el varactor para encontrar la que maximiza el desfase. |
| `FoM.m` | Apéndice E | Barrido de la figura de mérito $FoM(X_{add})$ con la restricción $\Delta\phi^{max} \geq 300^\circ$. |
| `Calculadora_IDC.m` | 4.1.2 | Interfaz de cálculo de la capacidad de un condensador interdigital en función de sus dimensiones ($N$, $L$, $W$, $S$). |
| `opcionesGraficas.m` | — | Función auxiliar con el formato común de las gráficas. La usan el resto de scripts. |
