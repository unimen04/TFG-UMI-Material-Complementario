%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Este calcula la reactancia en paralelo a añadir al varactor (pudiendo
    elegir el modelo del mismo) para aumentar el valor del desfase. Con él
    se evalúan todo un rango de X_add, dando el óptimo para esta tarea.

%}


clear; clc; close all;
opcionesGraficas;

%% Variables de diseño
Z0 = 50;
f = 3.5e9;
w = 2*pi*f;
VR = linspace(0, 15, 10001);
R_par_C = 0.2; % Resistencia parásita del condensador SMD

%% Varactor
%[Zvar] = SMV_1236_079LF_ideal(VR, f);
[Zvar] = SMV_1236_079LF_real(VR, f);

%% Cálculo X_add
X_vector = -50:0.01:50;
vector_rango_fase = zeros(size(X_vector));

for k = 1:length(X_vector)
    X = X_vector(k);
    
    Z_add = R_par_C + 1j * X; 
    
    % Varactor en paralelo a Z_add
    Z_in = (Z_add .* Zvar) ./ (Z_add + Zvar);
    
    % Coeficiente de reflexión
    Coef_reflexion = (Z_in - Z0) ./ (Z_in + Z0);
    
    % Fase coeficiente de reflexión
    fase = rad2deg(unwrap(angle(Coef_reflexion)));
    vector_rango_fase(k) = max(fase) - min(fase);
end

%% Optimización Fase
[max_rango_fase, idx_opt] = max(vector_rango_fase);
mejor_X = X_vector(idx_opt);

%% Resultados
figure('Name', 'Rango de Fase vs X_add', 'NumberTitle', 'off');
plot(X_vector, vector_rango_fase);
grid on;
title('Rango de Fase vs X_{add}');
xlabel('X_{add} [\Omega]');
ylabel('\Delta\angle\Gamma [^\circ]');
xline(mejor_X, '--r', sprintf('Max Fase: %.2f \\Omega', mejor_X), 'LineWidth', 2, 'FontSize', 12, 'FontWeight','bold','LabelVerticalAlignment', 'bottom');

%% Consola
fprintf('------------------------------------------------\n');
fprintf('Reactancia óptima añadida (Fase max): %.2f Ohm\n', mejor_X);
fprintf('Rango de fase conseguido:         %.2f Grados\n', max_rango_fase);
fprintf('------------------------------------------------\n');
fprintf('COMPONENTE A %.2f GHz (Optimizado para Fase):\n', f/1e9);

if mejor_X > 0
    L_add = mejor_X / w;
    fprintf('   Añadir BOBINA en paralelo:     %.2f nH\n', L_add * 1e9);
elseif mejor_X < 0
    C_add = -1 / (w * mejor_X);
    fprintf('   Añadir CONDENSADOR en paralelo: %.2f pF\n', C_add * 1e12);
else
    fprintf('   Cortocircuito (X = 0)\n');
end
fprintf('------------------------------------------------\n');