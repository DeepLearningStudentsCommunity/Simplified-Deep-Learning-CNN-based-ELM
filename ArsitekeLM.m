clc
clear all
close all
warning off

%% Parameter-parameter yang digunakan 
% 
% untuk normalisasi nilai dari fitur
max1 = 300;
min1 = 0;
max2 = 1;
min2 = 0;

%byk_fitur=4;
%bykData = 8;

% misal ada 3 filter convolution yang digunakan:
% ke-1 (conv11) : average filter
% ke-2 (conv12) : max filter
% ke-3 (conv13) : std filter
% bykFilter = 3;


% menentukan ukuran padding (pad_size=(k-1)/2), ukuran matrik filter (k x k) pada proses
% convolution
% k = 3; 

% sebagai filter [windows_size x windows_size]
% pada proses pooling
% windows_size=2;
% ws=windows_size;

%% Proses Training
% pre-Proses data training
[bykData,byk_fitur,target,norm]=FnPreProsesForELMonly('datatrainForcast.xlsx',...
    max1, min1, max2, min2);



% % byk_kelas=numel(unique(target));
% 
% 
% %% Masuk ke Proses CNN dan ELM
% %% ==========misal menggunakan Deep Learning dengan CNN + ELM
% %% =============== CNN no.1-no.8
% %% =============== misal dgn ELM no.9-no.11
% %%                 yang nantinya beberapa ELM tersebut di-voting
% %% =============== misal menggunakan urutan arsitek:
% %% 1. "Convolution"
% %% 2. "Sigmoid/ReLU/lainnya"
% %% 3. "Convolution"
% %% 4. "Sigmoid/ReLU/lainnya"
% %% 5. "Pooling"
% %% 6. "Convolution" 
% %% 7. "Sigmoid/ReLU/lainnya"
% %% 8. "Pooling"
% %% "9. Fully connected"
% %% "10. Fully connected"
% %% "11. Fully connected"
% 
% % dimana "Fully connected" dapat menggunakan Backpro atau ELM
% % jadi sebelum masuk "Fully connected" maka harus disiapkan 
% % dalam bentuk vektor (misal 1 baris banyak kolom) yg merupakan
% % gabungan dari beberapa pooling
% % misal disini menggunakan ELM
% 
% % ukuran setiap hasil [bykFilter x bykData]
% hC=FnConvDL(norm,bykData,k); % 1. Convolution di awal
% hA=FnSigDL(hC,bykFilter,bykData);   % 2. Aktivasi
% hC=FnConvInDL(hA,bykData,k,bykFilter); % 3. Convolution In
% hA=FnSigDL(hC,bykFilter,bykData);   % 4. Aktivasi
% hP=FnPoolDL(hA,windows_size,bykFilter,bykData);   % 5. Pooling
% hC=FnConvInDL(hP,bykData,k,bykFilter); % 6. Convolution In
% hA=FnSigDL(hC,bykFilter,bykData);   % 7. Aktivasi
% windows_size=1;
% hP=FnPoolDL(hA,windows_size,bykFilter,bykData);   % 8. Pooling
% 
% % reset lagi nilai windows_size
% windows_size=2;

hP = norm;

% 9. Fully connected ke-1, misal dengan train ELM
byk_neuron_hidden_layer=5;
[hFC11,W11,Bias11,Beta11]=FnELMtrainForcastForELMonly(hP,target,...
    byk_neuron_hidden_layer,bykData);

% 10. Fully connected ke-2, misal dengan train ELM
byk_neuron_hidden_layer=7;
[hFC12,W12,Bias12,Beta12]=FnELMtrainForcastForELMonly(hP,target,...
    byk_neuron_hidden_layer,bykData);

% 11. Fully connected ke-3, misal dengan train ELM
byk_neuron_hidden_layer=4;
[hFC13,W13,Bias13,Beta13]=FnELMtrainForcastForELMonly(hP,target,...
    byk_neuron_hidden_layer,bykData);
% [hFC1,hFC2]=FnELMClassify(Xtrain,Ytrain,byk_neuron_hidden_layer,...
%     Xtest,Ytest,bykData,bykFilter)


%% Proses Testing 
% ketika proses testing, maka melalui CNN seperti proses training, 
% lalu baru ke "Fully connected" misal dengan ELM, 
% lalu voting hasil ELM, dari kelas yg sering muncul

% pre-Proses data testing
[bykData2,byk_fitur2,target2,norm2]=FnPreProsesForELMonly('datatestForcast.xlsx',...
    max1, min1, max2, min2);

% %% lakukan CNN no.1-no.8
% hC2=FnConvDL(norm2,bykData2,k); % 1. Convolution di awal
% hA2=FnSigDL(hC2,bykFilter,bykData2);   % 2. Aktivasi
% hC2=FnConvInDL(hA2,bykData2,k,bykFilter); % 3. Convolution In
% hA2=FnSigDL(hC2,bykFilter,bykData2);   % 4. Aktivasi
% hP2=FnPoolDL(hA2,windows_size,bykFilter,bykData2);   % 5. Pooling
% hC2=FnConvInDL(hP2,bykData2,k,bykFilter); % 6. Convolution In
% hA2=FnSigDL(hC2,bykFilter,bykData2);   % 7. Aktivasi
% windows_size=1;
% hP2=FnPoolDL(hA2,windows_size,bykFilter,bykData2);   % 8. Pooling

hP2 = norm2;

% 9. Fully connected ke-1, misal dengan testing ELM
[vEvaluasi1,Ytest_predict1]=...
    FnELMtestForcastForELMonly(hP2,target2,...
    W11,Bias11,Beta11,bykData2);

% 10. Fully connected ke-2, misal dengan testing ELM
[vEvaluasi2,Ytest_predict2]=...
    FnELMtestForcastForELMonly(hP2,target2,...
    W12,Bias12,Beta12,bykData2);

% 11. Fully connected ke-3, misal dengan testing ELM
[vEvaluasi3,Ytest_predict3]=...
    FnELMtestForcastForELMonly(hP2,target2,...
    W13,Bias13,Beta13,bykData2);

%% proses voting (ambil nilai paling Minimum) 
% dari beberapa "Fully connected" testing ELM
% mengambil nilai prediksi (Ytest_predict) yang paling kecil vEvaluasi-nya
ComparevEvaluasi=[vEvaluasi1 vEvaluasi2 vEvaluasi3]

[vMin,idxMin]=min(ComparevEvaluasi')



disp("Done......!");














