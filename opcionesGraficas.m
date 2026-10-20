%{

    Trabajo de Fin de Grado
    Grado en Ingeniería de Tecnologías de Telecomunicación
    Diseño de circuitos desfasadores reflectivos de radiofrecuencia basados en cargas reactivas
    EPS - UAM
    AUTOR: Unai Mendoza Izquierdo

    Este código alberga la configuración global para todas las gráficas, a
    excepción de Cartas de Smith.

%}

function opcionesGraficas()
    
    % texto en Negrita y tamaño de fuente para todo
    set(groot, 'DefaultAxesFontSize', 20); %14 / 20
    set(groot, 'DefaultAxesFontWeight', 'bold');
    set(groot, 'DefaultTextFontSize', 22); %14/22
    set(groot, 'DefaultTextFontWeight', 'bold');
    
    % grosor de línea
    set(groot, 'DefaultLineLineWidth', 6); %4/6
    
    % grosor del marco de la gráfica
    set(groot, 'DefaultAxesLineWidth', 2);
    
    % leyenda: ubicación automática
    set(groot, 'DefaultLegendLocation', 'best');
    set(groot, 'DefaultLegendFontSize', 12); % 12/22
    
    % grid siempre activado
    set(groot, 'DefaultAxesXGrid', 'on');
    set(groot, 'DefaultAxesYGrid', 'on');
    set(groot, 'DefaultAxesZGrid', 'on');

end