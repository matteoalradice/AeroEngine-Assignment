function [] = export_image(filename,n_fig,orientation)

% Setting units
set(gcf, 'Units', 'centimeters');

% Setting font
set(gca, 'FontSize', 10, 'FontName', 'Times New Roman'); 

% Setting position
pos = get(gcf, 'Position');

switch n_fig
    case 1
        width = 11;

        switch lower(orientation)
            case 'vertical'
                height = width * 3 / 2;      
                
            case 'horizontal'
                height = width * 2 / 3;
        end

    case 2
        width = 7;

        switch lower(orientation)
            case 'vertical'
                height = width * 3 / 2;      
                
            case 'horizontal'
                height = width * 2 / 3;
        end
end

% Scaling image
set(gcf,'Position', [pos(1), pos(2), width, height]);

% Exporting image
exportgraphics(gcf, [filename,'.pdf'], 'ContentType', 'vector');