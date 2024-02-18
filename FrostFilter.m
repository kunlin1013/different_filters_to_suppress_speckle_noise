function IMG =  FrostFilter(img,varargin)
    % img : input image
    % IMG : output image => invert to uint8

    img = double(img);
    % window_m, window_n : m×n window region
    defaultwindow_m = 3;
    defaultwindow_n = 3;
    % Damping factor
    defaultDamp_fact = 1;
    
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'img',@(x) validateattributes(x,{'numeric'},{}));
    addOptional(p,'window_m',defaultwindow_m,validScalarPosNum);
    addOptional(p,'window_n',defaultwindow_n,validScalarPosNum);
    addOptional(p,'Damp_fact',defaultDamp_fact,validScalarPosNum);
    parse(p,img,varargin{:});
    
    % window size
    sz = [p.Results.window_m p.Results.window_n];

    % Preallocate the Output Matrix
    IMG = zeros(size(p.Results.img));
    if(~all(mod(sz,2) == [1 1]))
        sz = sz + ~mod(sz,2);
    end
    mn = round((sz - 1) / 2);

    % Padding with symmetric around the border
    img_padding = padarray(p.Results.img,mn,'symmetric');

    [x,y]= meshgrid(-mn(1,1):mn(1,1),-mn(1,2):mn(1,2));
    S = sqrt(x.^2+y.^2);

    for i = 1:size(p.Results.img,1)
        for j = 1:size(p.Results.img,2)
            % Local Window
            K = img_padding(i:i+sz(1,1)-1,j:j+sz(1,2)-1);

            % Mean value of the pixels in the local window
            meanV = mean(K(:));

            % variance of the pixels in the local window
            varV = var(K(:));

            % Weight for each pixel in the local window
            B =  p.Results.Damp_fact*(varV/(meanV*meanV));
            Weight = exp(-S.*B);

            % Filtering
            IMG(i,j) = sum(K(:).*Weight(:))./sum(Weight(:));
        end
    end
    IMG = uint8(IMG);
end