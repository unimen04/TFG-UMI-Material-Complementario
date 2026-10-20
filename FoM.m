%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Este código devuelve la FoM en º/dB para un límite mínimo de desfase a
    conseguir, devolviendo también el valor X_add para el que se consigue.
    Se puede tener en cuenta la posible resistencia parásita del
    condensador en paralelo.

    Éste código ha sido desarrollado con ayuda de Google Gemini 3.1 Pro.

%}

clear; clc; close all;
opcionesGraficas;

%% Variables de diseño
Z0 = 50;
f = 3.5e9;
w = 2*pi*f;
VR = linspace(0, 15, 10001);
R_par_C = 0.2; % Resistencia parásita del condensador SMD
MIN_RANGO_FASE_DEG = 300; % Límite mínimo de fase para la FoM

%% Varactor
%[Zvar] = SMV_1236_079LF_ideal(VR, f);
[Zvar] = SMV_1236_079LF_real(VR, f);

%% Cálculo X_add
X_vector = -20:0.01:20;
vector_rango_fase = zeros(size(X_vector));
vector_min_mod = zeros(size(X_vector));

for k = 1:length(X_vector)
    X = X_vector(k);
    
    Z_add = R_par_C + 1j * X; 
    
    % Varactor en paralelo a Z_add
    Z_in = (Z_add .* Zvar) ./ (Z_add + Zvar);
    
    % Coeficiente de reflexión
    Coef_reflexion = (Z_in - Z0) ./ (Z_in + Z0);
    
    fase = rad2deg(unwrap(angle(Coef_reflexion)));
    
    vector_rango_fase(k) = max(fase) - min(fase);
    vector_min_mod(k) = min(abs(Coef_reflexion));
end

%% Cálculo de FoM (deg/dB) limitada
mask_valida = vector_rango_fase >= MIN_RANGO_FASE_DEG;
vec_min_mod_safe = max(vector_min_mod, 1e-6);
perdidas_max_dB = -20 * log10(vec_min_mod_safe);
perdidas_max_dB(perdidas_max_dB < 1e-4) = 1e-4;

vector_fom = zeros(size(X_vector));
vector_fom(mask_valida) = vector_rango_fase(mask_valida) ./ perdidas_max_dB(mask_valida);

[max_fom, idx_opt_fom] = max(vector_fom);
mejor_X_fom = X_vector(idx_opt_fom);

%% Resultados
figure('Name', 'FoM vs X_add', 'NumberTitle', 'off');
hold on; grid on;

plot(X_vector, vector_fom, '-d', 'LineWidth', 4, 'MarkerSize', 4, ...
    'Color', [0.85 0.33 0.1], 'HandleVisibility', 'off');

title(sprintf('FoM [^\\circ/dB] (\\Delta\\angle\\Gamma \\geq %d^\\circ, f = %.1f GHz, Z_0 = %d \\Omega)', MIN_RANGO_FASE_DEG, f/1e9, Z0));
xlabel('X_{add} [\Omega]');
ylabel('FoM [^\circ/dB]');

if any(mask_valida)
    plot(mejor_X_fom, max_fom, 'o', 'MarkerSize', 8, ...
        'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k', ...
        'DisplayName', sprintf('Max: X_{add} = %.1f \\Omega (%.1f ^\\circ/dB)', mejor_X_fom, max_fom));
    legend('show', 'Location', 'best');
end
hold off;

%% Consola
fprintf('------------------------------------------------\n');
if any(mask_valida)
    fprintf('Reactancia óptima añadida (FoM max): %.2f Ohm\n', mejor_X_fom);
    fprintf('FoM máxima conseguida:            %.2f º/dB\n', max_fom);
else
    fprintf('No se ha encontrado ninguna reactancia que alcance los %dº.\n', MIN_RANGO_FASE_DEG);
end
fprintf('------------------------------------------------\n');
fprintf('COMPONENTE A %.2f GHz (Optimizado para FoM):\n', f/1e9);

if any(mask_valida)
    if mejor_X_fom > 0
        L_add = mejor_X_fom / w;
        fprintf('   Añadir BOBINA en paralelo:     %.2f nH\n', L_add * 1e9);
    elseif mejor_X_fom < 0
        C_add = -1 / (w * mejor_X_fom);
        fprintf('   Añadir CONDENSADOR en paralelo: %.2f pF\n', C_add * 1e12);
    else
        fprintf('   Cortocircuito (X = 0)\n');
    end
end
fprintf('------------------------------------------------\n');