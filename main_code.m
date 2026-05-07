clc; close all; clear;

%% ============ COLOR THEME ============
BG       = [0.07 0.07 0.09];
PANEL    = [0.11 0.11 0.13];
TXT      = [0.92 0.92 0.94];
SUBTXT   = [0.55 0.55 0.62];
ACCENT   = [0.45 0.40 0.95];
GREEN    = [0.20 0.78 0.45];
ORANGE   = [0.95 0.55 0.25];
NEUTRAL  = [0.18 0.18 0.22];
BTNTXT   = [1 1 1];

%% ============ FIGURE ============
f = figure('Name','Lightweight RGB QR Image Encryption System',...
    'Units','pixels','Position',[20 20 1300 720],...
    'Color',BG,'NumberTitle','off','MenuBar','none','ToolBar','none');

%% ============ HEADER ============
uicontrol(f,'Style','text',...
    'String','Lightweight RGB QR Image Encryption System',...
    'FontSize',15,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',BG,...
    'HorizontalAlignment','left',...
    'Position',[30 685 700 24]);

uicontrol(f,'Style','text',...
    'String','XOR diffusion on R,G  |  Power-law transform on B  |  QR binary encoding',...
    'FontSize',9,...
    'ForegroundColor',SUBTXT,'BackgroundColor',BG,...
    'HorizontalAlignment','left',...
    'Position',[30 666 700 18]);

handles.statusPill = uicontrol(f,'Style','text',...
    'String','  Ready',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',[0.6 0.6 0.7],'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[1140 680 130 24]);

%% ============ BUTTON ROW ============
btnY = 620; btnH = 36;

uicontrol(f,'Style','pushbutton','String','Load Image',...
    'FontSize',10,'FontWeight','bold',...
    'BackgroundColor',NEUTRAL,'ForegroundColor',BTNTXT,...
    'Position',[30 btnY 120 btnH],'Callback',@loadImage);

uicontrol(f,'Style','pushbutton','String','Encrypt',...
    'FontSize',10,'FontWeight','bold',...
    'BackgroundColor',ACCENT,'ForegroundColor',BTNTXT,...
    'Position',[160 btnY 110 btnH],'Callback',@encryptImage);

uicontrol(f,'Style','pushbutton','String','Decrypt',...
    'FontSize',10,'FontWeight','bold',...
    'BackgroundColor',GREEN,'ForegroundColor',BTNTXT,...
    'Position',[280 btnY 110 btnH],'Callback',@decryptImage);

uicontrol(f,'Style','pushbutton','String','Save Binary (.txt)',...
    'FontSize',10,'FontWeight','bold',...
    'BackgroundColor',ORANGE,'ForegroundColor',BTNTXT,...
    'Position',[400 btnY 150 btnH],'Callback',@saveBinary);

uicontrol(f,'Style','pushbutton','String','Reset',...
    'FontSize',10,'FontWeight','bold',...
    'BackgroundColor',NEUTRAL,'ForegroundColor',SUBTXT,...
    'Position',[560 btnY 90 btnH],'Callback',@resetGUI);

%% ============ ORIGINAL IMAGE PANEL ============
pOrig = uipanel(f,'Units','pixels','Position',[30 360 380 240],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pOrig,'Style','text','String','Original Image',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 215 200 18]);
handles.axOriginal = axes('Parent',pOrig,'Units','pixels',...
    'Position',[20 15 340 195]);
showPlaceholder(handles.axOriginal,'No image loaded',SUBTXT,PANEL);

%% ============ ENCRYPTED OUTPUT PANEL ============
pEnc = uipanel(f,'Units','pixels','Position',[420 360 380 240],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pEnc,'Style','text','String','Encrypted Image (Cipher)',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 215 200 18]);
handles.axEnc = axes('Parent',pEnc,'Units','pixels',...
    'Position',[20 15 340 195]);
showPlaceholder(handles.axEnc,'Encrypted output appears here',SUBTXT,PANEL);

%% ============ DECRYPTED OUTPUT PANEL ============
pDec = uipanel(f,'Units','pixels','Position',[810 360 380 240],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pDec,'Style','text','String','Decrypted Image',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 215 200 18]);
handles.axDec = axes('Parent',pDec,'Units','pixels',...
    'Position',[20 15 340 195]);
showPlaceholder(handles.axDec,'Decrypted output appears here',SUBTXT,PANEL);

%% ============ HISTOGRAM PANEL ============
pHist = uipanel(f,'Units','pixels','Position',[30 200 1240 145],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pHist,'Style','text','String','Histogram Analysis - Plain vs Cipher',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 120 400 18]);

histLabels = {'Plain R','Cipher R','Plain G','Cipher G','Plain B','Cipher B'};
histColors = {[0.95 0.45 0.45],[0.95 0.45 0.45],...
              [0.50 0.85 0.45],[0.50 0.85 0.45],...
              [0.55 0.65 0.95],[0.55 0.65 0.95]};

histW = 180; histGap = 15;
for i = 1:6
    xPos = 20 + (i-1)*(histW+histGap);
    
    uicontrol(pHist,'Style','text','String',histLabels{i},...
        'FontSize',9,'FontWeight','bold',...
        'ForegroundColor',histColors{i},'BackgroundColor',PANEL,...
        'HorizontalAlignment','left',...
        'Position',[xPos 95 histW 14]);
    
    handles.axHist(i) = axes('Parent',pHist,'Units','pixels',...
        'Position',[xPos 15 histW 80]);
    showEmptyHist(handles.axHist(i),PANEL);
end
handles.histColors = histColors;

%% ============ METRICS PANEL ============
pMet = uipanel(f,'Units','pixels','Position',[30 100 770 90],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pMet,'Style','text','String','Security Metrics',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 65 200 18]);

metricNames  = {'Entropy','NPCR (%)','UACI (%)','Correlation'};
metricIdeals = {'~ 8.0','> 99.6','~ 33.4','~ 0.00'};
metricColors = {[0.35 0.75 0.95],[0.45 0.85 0.50],[0.95 0.78 0.35],[0.65 0.55 0.95]};

mW = 175; mGap = 10;
for i = 1:4
    xPos = 15 + (i-1)*(mW+mGap);
    
    uicontrol(pMet,'Style','text','String',metricNames{i},...
        'FontSize',9,...
        'ForegroundColor',SUBTXT,'BackgroundColor',PANEL,...
        'HorizontalAlignment','left',...
        'Position',[xPos 45 mW 14]);
    
    handles.metricVal(i) = uicontrol(pMet,'Style','text','String','--',...
        'FontSize',18,'FontWeight','bold',...
        'ForegroundColor',metricColors{i},'BackgroundColor',PANEL,...
        'HorizontalAlignment','left',...
        'Position',[xPos 18 mW 28]);
    
    uicontrol(pMet,'Style','text','String',metricIdeals{i},...
        'FontSize',8,...
        'ForegroundColor',SUBTXT,'BackgroundColor',PANEL,...
        'HorizontalAlignment','left',...
        'Position',[xPos 5 mW 12]);
end

%% ============ PARAMETER PANEL ============
pPar = uipanel(f,'Units','pixels','Position',[810 100 460 90],...
    'BackgroundColor',PANEL,'BorderType','line',...
    'HighlightColor',[0.18 0.18 0.22],'ShadowColor',PANEL);
uicontrol(pPar,'Style','text','String','Encryption Parameters',...
    'FontSize',10,'FontWeight','bold',...
    'ForegroundColor',TXT,'BackgroundColor',PANEL,...
    'HorizontalAlignment','left',...
    'Position',[12 65 200 18]);

labels   = {'S','n','Xn','M','I','m'};
defaults = {'0.7531','3','0.5','7919','997','65537'};

pW = 65; pGap = 6;
for i = 1:6
    xPos = 15 + (i-1)*(pW+pGap);
    
    uicontrol(pPar,'Style','text','String',labels{i},...
        'FontSize',9,'FontWeight','bold',...
        'ForegroundColor',SUBTXT,'BackgroundColor',PANEL,...
        'HorizontalAlignment','center',...
        'Position',[xPos 45 pW 14]);
    
    handles.boxes(i) = uicontrol(pPar,'Style','edit',...
        'String',defaults{i},'FontSize',10,'FontWeight','bold',...
        'ForegroundColor',TXT,'BackgroundColor',[0.16 0.16 0.20],...
        'HorizontalAlignment','center',...
        'Position',[xPos 12 pW 28]);
end

%% ============ FOOTER ============
uicontrol(f,'Style','text',...
    'String','Tip: change any parameter then click Decrypt to demonstrate key-sensitivity. Save Binary writes 0/1 text file.',...
    'FontSize',9,...
    'ForegroundColor',SUBTXT,'BackgroundColor',BG,...
    'HorizontalAlignment','left',...
    'Position',[30 75 1240 16]);

guidata(f,handles)


%% =========================================================
%% =================== HELPERS =============================
%% =========================================================
function showPlaceholder(ax, msg, txtColor, bg)
    cla(ax,'reset')
    set(ax,'Color',bg,'XColor',bg,'YColor',bg,'Box','off')
    if ~isempty(msg)
        text(ax,0.5,0.5,msg,'Units','normalized',...
            'HorizontalAlignment','center','VerticalAlignment','middle',...
            'Color',txtColor,'FontSize',9);
    end
    axis(ax,'off')
end

function showEmptyHist(ax, bg)
    cla(ax,'reset')
    set(ax,'Color',bg,'XColor',bg,'YColor',bg,'Box','off')
    axis(ax,'off')
end

function setStatus(handles, txt, col)
    set(handles.statusPill,'String',['  ' txt],'ForegroundColor',col);
end


%% =========================================================
%% =========== KEYSTREAM (proper PRSG) =====================
%% =========================================================
function keystream = generateKeystream(S, ~, Xn, M, I, m, N, plainSeed)
    % plainSeed: optional plaintext-derived perturbation for NPCR/UACI sensitivity
    if nargin < 8 || isempty(plainSeed)
        plainSeed = 0;
    end
    
    keystream = zeros(N,1,'uint8');
    
    % --- mix plaintext seed into initial state (avalanche effect) ---
    x = mod(Xn + plainSeed * 1e-9, 1);
    if x == 0; x = Xn + 0.001; end
    
    Mp = M + mod(plainSeed, 1009);   % perturb M too
    
    for k = 1:N
        x = mod(x * Mp * I + S*1e6, m);
        if x == 0; x = mod(Mp+k, m); end
        keystream(k) = uint8(mod(floor(x * 2^16 / max(m,1)), 256));
    end
end


%% =========================================================
%% ================== LOAD IMAGE ===========================
%% =========================================================
function loadImage(src,~)
    handles = guidata(src);
    [file,path] = uigetfile({'*.jpg;*.png;*.bmp;*.jpeg;*.tif'});
    if isequal(file,0); return; end
    
    img = imread(fullfile(path,file));
    if size(img,3) == 1
        img = cat(3,img,img,img);
    end
    
    if max(size(img,1),size(img,2)) > 256
        img = imresize(img,[256 256]);
    end
    
    handles.original = img;
    
    cla(handles.axOriginal,'reset')
    imshow(img,'Parent',handles.axOriginal)
    axis(handles.axOriginal,'off')
    
    R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
    
    plotHist(handles.axHist(1), R, handles.histColors{1})
    plotHist(handles.axHist(3), G, handles.histColors{3})
    plotHist(handles.axHist(5), B, handles.histColors{5})
    
    showEmptyHist(handles.axHist(2),[0.11 0.11 0.13])
    showEmptyHist(handles.axHist(4),[0.11 0.11 0.13])
    showEmptyHist(handles.axHist(6),[0.11 0.11 0.13])
    
    for i = 1:4
        set(handles.metricVal(i),'String','--');
    end
    
    setStatus(handles,'Loaded',[0.6 0.7 0.95])
    guidata(src,handles)
end


%% =========================================================
%% ================== ENCRYPT (B-channel fixed) ============
%% =========================================================
function encryptImage(src,~)
    handles = guidata(src);
    
    if ~isfield(handles,'original')
        errordlg('Load an image first.'); return
    end
    
    vals = cellfun(@str2double,{handles.boxes.String});
    S = vals(1); n = vals(2); Xn = vals(3);
    M = vals(4); I = vals(5); m = vals(6);
    
    img = handles.original;
    R = img(:,:,1); G = img(:,:,2); B = img(:,:,3);
    [rows,cols] = size(R);
    Npix = rows*cols;
    
    % --- plaintext-derived seed (sum mod a prime) for NPCR/UACI sensitivity ---
    plainSeed = mod(sum(double(img(:))), 999983);
    handles.plainSeed = plainSeed;
    
    % --- generate keystream once ---
    keystream = generateKeystream(S,n,Xn,M,I,m,Npix,plainSeed);
    keyMatrix = reshape(keystream, rows, cols);
    
    % --- R, G channels: pure XOR (perfectly reversible) ---
    handles.R_enc = bitxor(R, keyMatrix);
    handles.G_enc = bitxor(G, keyMatrix);
    
    % --- B channel (FIXED reversible pipeline) ---
    % Step 1: power-law transform on normalized B
    B_norm = double(B) / 255;
    B_norm = max(B_norm, 1e-6);          % avoid 0^(1/n) issues
    Sb = max(min(S,1),0.01);              % clamp S to [0.01,1]
    
    B_power = real((Sb - B_norm.^(1/n)).^n);
    
    % Step 2: scale to 0-255 using FIXED bounds (not data-dependent)
    % Theoretical bounds of f(x) = (S - x^(1/n))^n for x in [0,1]:
    %   when x=0:  f = S^n
    %   when x=1:  f = (S-1)^n
    % We use [-1, 1] as a safe wide range that always contains the output
    B_scaled = (B_power + 1) / 2;          % map [-1,1] -> [0,1]
    B_scaled = min(max(B_scaled, 0), 1);   % clamp
    B_uint = uint8(round(B_scaled * 255));
    
    % Step 3: XOR with keystream for diffusion
    handles.B_enc = bitxor(B_uint, keyMatrix);
    
    % --- assemble cipher ---
    handles.cipher = cat(3, handles.R_enc, handles.G_enc, handles.B_enc);
    handles.keyMatrix = keyMatrix;
    
    % --- show cipher ---
    cla(handles.axEnc,'reset')
    imshow(handles.cipher,'Parent',handles.axEnc)
    axis(handles.axEnc,'off')
    
    % clear decrypted panel
    showPlaceholder(handles.axDec,'Click Decrypt',[0.55 0.55 0.62],[0.11 0.11 0.13]);
    
    % --- update histograms ---
    plotHist(handles.axHist(1), R, handles.histColors{1})
    plotHist(handles.axHist(2), handles.R_enc, handles.histColors{2})
    plotHist(handles.axHist(3), G, handles.histColors{3})
    plotHist(handles.axHist(4), handles.G_enc, handles.histColors{4})
    plotHist(handles.axHist(5), B, handles.histColors{5})
    plotHist(handles.axHist(6), handles.B_enc, handles.histColors{6})
    
    % --- compute metrics ---
    updateMetrics(handles, S, n, Xn, M, I, m)
    
    setStatus(handles,'Encrypted',[0.45 0.85 0.50])
    guidata(src,handles)
end


%% =========================================================
%% ================== DECRYPT (B-channel fixed) ============
%% =========================================================
function decryptImage(src,~)
    handles = guidata(src);
    
    if ~isfield(handles,'R_enc')
        errordlg('Encrypt an image first.'); return
    end
    
    vals = cellfun(@str2double,{handles.boxes.String});
    S = vals(1); n = vals(2); Xn = vals(3);
    M = vals(4); I = vals(5); m = vals(6);
    
    [rows,cols] = size(handles.R_enc);
    Npix = rows*cols;
    
    % regenerate keystream using the stored plaintext seed
    if isfield(handles,'plainSeed')
        plainSeed = handles.plainSeed;
    else
        plainSeed = 0;
    end
    keystream = generateKeystream(S,n,Xn,M,I,m,Npix,plainSeed);
    keyMatrix = reshape(keystream, rows, cols);
    
    % --- R, G: XOR back ---
    R_dec = bitxor(handles.R_enc, keyMatrix);
    G_dec = bitxor(handles.G_enc, keyMatrix);
    
    % --- B channel: reverse the pipeline EXACTLY as encrypt did ---
    % Step 1 reverse: undo XOR
    B_uint = bitxor(handles.B_enc, keyMatrix);
    
    % Step 2 reverse: undo scaling
    B_scaled = double(B_uint) / 255;          % back to [0,1]
    B_power = B_scaled * 2 - 1;                % undo (x+1)/2 mapping -> [-1,1]
    
    % Step 3 reverse: undo power-law transform
    %   f(x) = (S - x^(1/n))^n
    %   x = (S - f^(1/n))^n
    Sb = max(min(S,1),0.01);
    
    % handle negative B_power values for non-integer n
    B_power_signed_root = sign(B_power) .* abs(B_power).^(1/n);
    B_norm_recovered = real((Sb - B_power_signed_root).^n);
    B_norm_recovered = sign(B_norm_recovered) .* abs(B_norm_recovered);
    B_norm_recovered = min(max(B_norm_recovered, 0), 1);
    
    B_dec = uint8(round(B_norm_recovered * 255));
    
    decImg = cat(3, R_dec, G_dec, B_dec);
    
    cla(handles.axDec,'reset')
    imshow(decImg,'Parent',handles.axDec)
    axis(handles.axDec,'off')
    
    setStatus(handles,'Decrypted',[0.45 0.85 0.50])
end


%% =========================================================
%% ================== SAVE BINARY (.txt 0/1) ===============
%% =========================================================
function saveBinary(src,~)
    handles = guidata(src);
    
    if ~isfield(handles,'cipher')
        errordlg('Encrypt an image first before saving.'); return
    end
    
    [file,path] = uiputfile({'*.txt','Text Binary File (*.txt)'},...
        'Save encrypted image as binary text','encrypted_image.txt');
    
    if isequal(file,0); return; end
    
    fullpath = fullfile(path,file);
    
    setStatus(handles,'Saving...',[0.95 0.55 0.25])
    drawnow;
    
    cipher = handles.cipher;
    [rows,cols,~] = size(cipher);
    
    % --- vectorized binary conversion (whole channels at once) ---
    R_bits = dec2bin(cipher(:,:,1), 8);
    G_bits = dec2bin(cipher(:,:,2), 8);
    B_bits = dec2bin(cipher(:,:,3), 8);
    
    % --- build full text in memory using vectorized ops (FAST) ---
    nl = newline;
    
    header = sprintf([...
        '# Lightweight RGB QR Encrypted Image - Binary Export\n' ...
        '# Image dimensions: %d x %d (rows x cols)\n' ...
        '# Total pixels: %d\n' ...
        '# Format: 8 bits per line per pixel, channels stacked R then G then B\n' ...
        '# ================================================================\n\n'], ...
        rows, cols, rows*cols);
    
    % append newline char to each row, then flatten — one shot per channel
    R_text = reshape([R_bits, repmat(nl,size(R_bits,1),1)].', 1, []);
    G_text = reshape([G_bits, repmat(nl,size(G_bits,1),1)].', 1, []);
    B_text = reshape([B_bits, repmat(nl,size(B_bits,1),1)].', 1, []);
    
    fullText = [header ...
        '## RED CHANNEL (encrypted)' nl R_text nl ...
        '## GREEN CHANNEL (encrypted)' nl G_text nl ...
        '## BLUE CHANNEL (encrypted)' nl B_text];
    
    % --- single bulk write ---
    fid = fopen(fullpath, 'w');
    if fid == -1
        errordlg('Could not open file for writing.');
        setStatus(handles,'Error',[0.9 0.4 0.4])
        return
    end
    fwrite(fid, fullText, 'char');
    fclose(fid);
    
    fInfo = dir(fullpath);
    fileSizeKB = fInfo.bytes / 1024;
    
    msgbox(sprintf(['Encrypted binary saved successfully.\n\n' ...
        'Location: %s\n' ...
        'Size: %.1f KB\n' ...
        'Total bits: %d\n' ...
        'Format: 0/1 text, 8 bits per line per pixel'],...
        fullpath, fileSizeKB, rows*cols*3*8),...
        'Save Successful');
    
    setStatus(handles,'Saved',[0.95 0.55 0.25])
end


%% =========================================================
%% ================== RESET ================================
%% =========================================================
function resetGUI(src,~)
    handles = guidata(src);
    
    fields = {'original','cipher','R_enc','G_enc','B_enc','keyMatrix','plainSeed'};
    for k = 1:numel(fields)
        if isfield(handles,fields{k})
            handles = rmfield(handles,fields{k});
        end
    end
    
    PANEL  = [0.11 0.11 0.13];
    SUBTXT = [0.55 0.55 0.62];
    
    showPlaceholder(handles.axOriginal,'No image loaded',SUBTXT,PANEL);
    showPlaceholder(handles.axEnc,'Encrypted output appears here',SUBTXT,PANEL);
    showPlaceholder(handles.axDec,'Decrypted output appears here',SUBTXT,PANEL);
    
    for i = 1:6
        showEmptyHist(handles.axHist(i),PANEL)
    end
    
    for i = 1:4
        set(handles.metricVal(i),'String','--');
    end
    
    setStatus(handles,'Ready',[0.6 0.6 0.7])
    guidata(src,handles)
end


%% =========================================================
%% ============ HISTOGRAM PLOT =============================
%% =========================================================
function plotHist(ax, channel, col)
    PANEL = [0.11 0.11 0.13];
    cla(ax,'reset')
    h = histcounts(channel(:),0:8:256);
    bar(ax, h, 'FaceColor',col,'EdgeColor','none','BarWidth',0.85)
    set(ax,'Color',PANEL,'XColor',PANEL,'YColor',PANEL,...
        'XTick',[],'YTick',[],'Box','off')
    axis(ax,'tight')
end


%% =========================================================
%% ============ METRICS ====================================
%% =========================================================
function updateMetrics(handles, S, n, Xn, M, I, m)
    plain  = handles.original;
    cipher = handles.cipher;
    
    plain2 = plain;
    if plain2(1,1,1) < 255
        plain2(1,1,1) = plain2(1,1,1) + 1;
    else
        plain2(1,1,1) = plain2(1,1,1) - 1;
    end
    
    [rows,cols] = size(plain(:,:,1));
    Npix = rows*cols;
    
    % --- compute fresh plaintext seed for the flipped image ---
    % This is the key: even a 1-pixel change in plain creates a totally
    % different keystream, causing avalanche effect across entire cipher.
    plainSeed2 = mod(sum(double(plain2(:))), 999983);
    
    keystream = generateKeystream(S,n,Xn,M,I,m,Npix,plainSeed2);
    keyMatrix = reshape(keystream, rows, cols);
    
    R2 = bitxor(plain2(:,:,1),keyMatrix);
    G2 = bitxor(plain2(:,:,2),keyMatrix);
    
    B2_norm = double(plain2(:,:,3))/255;
    B2_norm = max(B2_norm, 1e-6);
    Sb = max(min(S,1),0.01);
    B2_power = real((Sb - B2_norm.^(1/n)).^n);
    B2_scaled = min(max((B2_power + 1)/2, 0), 1);
    B2_uint = uint8(round(B2_scaled * 255));
    B2 = bitxor(B2_uint, keyMatrix);
    
    cipher2 = cat(3,R2,G2,B2);
    
    diffMap = cipher ~= cipher2;
    NPCR = 100 * sum(diffMap(:)) / numel(diffMap);
    UACI = 100 * mean(abs(double(cipher(:)) - double(cipher2(:)))) / 255;
    
    H_R = entropyCalc(cipher(:,:,1));
    H_G = entropyCalc(cipher(:,:,2));
    H_B = entropyCalc(cipher(:,:,3));
    H_avg = mean([H_R H_G H_B]);
    
    cR = adjCorr(cipher(:,:,1));
    cG = adjCorr(cipher(:,:,2));
    cB = adjCorr(cipher(:,:,3));
    corrAvg = mean([cR cG cB]);
    
    set(handles.metricVal(1),'String',sprintf('%.4f',H_avg));
    set(handles.metricVal(2),'String',sprintf('%.4f',NPCR));
    set(handles.metricVal(3),'String',sprintf('%.4f',UACI));
    set(handles.metricVal(4),'String',sprintf('%.4f',corrAvg));
end

function H = entropyCalc(channel)
    p = histcounts(channel(:),0:256,'Normalization','probability');
    p = p(p>0);
    H = -sum(p .* log2(p));
end

function r = adjCorr(channel)
    N = 5000;
    [rows,cols] = size(channel);
    rIdx = randi(rows, N, 1);
    cIdx = randi(cols-1, N, 1);
    x = double(channel(sub2ind(size(channel),rIdx,cIdx)));
    y = double(channel(sub2ind(size(channel),rIdx,cIdx+1)));
    r = corr(x,y);
end