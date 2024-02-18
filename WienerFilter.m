function IMG = WienerFilter(img,varargin)
    % img : input image
    % IMG : output image => invert to uint8

    img = double(img);
    % window_m, window_n : m×n window region
    defaultwindow_m = 3;
    defaultwindow_n = 3; 
    sz = [defaultwindow_m defaultwindow_n];
    % additive noise variance
    default_additive_noise = mean2(filter2(ones(sz), img.^2) / prod(sz) - filter2(ones(sz), img) / prod(sz).^2);
    
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'img',@(x) validateattributes(x,{'numeric'},{}));
    addOptional(p,'window_m',defaultwindow_m,validScalarPosNum);
    addOptional(p,'window_n',defaultwindow_n,validScalarPosNum);
    addOptional(p,'additive_noise',default_additive_noise);
    parse(p,img,varargin{:});
    
    % window size
    sz = [p.Results.window_m p.Results.window_n];

    if(~all(mod(sz,2) == [1 1]))
        sz = sz + ~mod(sz,2);
    end
    mn = round((sz - 1) / 2);
    
    % Padding with symmetric around the border
    img_padding = padarray(p.Results.img,mn,'symmetric');

    % Estimate the local mean of f.
    localMean = filter2(ones(sz), img_padding) / prod(sz);

    % Estimate of the local variance of f.
    localVar = filter2(ones(sz), img_padding.^2) / prod(sz) - localMean.^2;

    if (p.Results.additive_noise == default_additive_noise)
        noise = mean2(localVar);
    else
        noise = p.Results.additive_noise;
    end
    
    f = img_padding - localMean;
    g = localVar - noise; 
    g = max(g, 0);
    localVar = max(localVar, noise);
    f = f ./ localVar;
    f = f .* g;
    IMG = f + localMean;
    IMG = IMG(mn(1):size(img_padding,1)-mn(1),mn(2):size(img_padding,2)-mn(2));

    IMG = uint8(IMG);
end