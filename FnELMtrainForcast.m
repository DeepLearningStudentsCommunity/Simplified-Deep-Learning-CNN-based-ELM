function [Result,W,BiasofHiddenNeurons,Beta_topi]=FnELMtrainForcast(hP,target,byk_neuron_hidden_layer,...
    bykData,bykFilter)

%  Algoritma Extreme Learning Machine (ELM)
%
%
%  Parameters: X      - inputs value
%              Y      - target value
%
%  Author: Imam Cholissodin (imam.cholissodin@gmail.com)

% ----------------------------------------
% |           X           |      Y       |
% ----------------------------------------
% | No | X1 | X2 | ..| Xk | Y1 | Y2 | Yi |
% ----------------------------------------
% | 1  | 3  | 3  | ..| 2  | 1  |    |    |
% ----------------------------------------
% | 2  |
% | .  |
% | .  |
% | n  |
% ----------------------------------------

%% Inisialisasi
%    % input data (X)
%    X=...
%     [3 3 2; % Data ke-1
%     3 2 2;  % Data ke-2
%     3 2 1;  % Data ke-3
%     3 1 1;  % 4
%     2 3 2;  % 5
%     2 2 2;  % 6
%     2 2 1;  % 7
%     2 1 1;  % 8
%     1 3 2;  % 9
%     1 2 1;  % 10
%     1 1 2]  % Data ke-n

byk_dim_data_input=bykFilter*numel(hP{1}{1}(:)');
X=zeros(bykData,byk_dim_data_input);

% hP{1}{1}
% numel(hP{1}{1}(:)')
% hP{2}{1}
% hP{3}{1}
% 
% hP{1}{2}
% hP{2}{2}
% hP{3}{2}
% 
% artinya koding dibawah ini adalah
% banyaknya fitur sama dengan banyak filter
% X2=zeros(bykData,bykFilter);
% for i=1:bykData
%     hP_init0=[];
%     for j=1:bykFilter
%         hP_init0=[hP_init0 mean(hP{j}{i}(:)')];
%     end
%     %hP_init0
%     hP_init0
%     %X2(i,:)=mean(hP_init0);    
%     X2(i,:)=hP_init0;   
% end

% X2
% pause(50000)

% convert kelas target ke vektor
% byk_kelas=numel(unique(target));
% Y=-ones(bykData,byk_kelas);
Y = target';
% for i=1:bykData
%     Y(i,target(i))=1;
% end

% get data training dari hasil pooling
% yang sudah diubah dalam bentuk vektor
for i=1:bykData
    hP_init=[];
    for j=1:bykFilter
        hP_init=[hP_init hP{j}{i}(:)'];
    end
    %hP_init
    X(i,:)=hP_init;    
end

%X;

%     hP{1}{2}
%     hP{2}{2}
%     hP{3}{2}
%     X(2,:)

%  target
% Y
% pause(50000000);


    % output layer
    % misal terdapat 3 kelas
%     % kelas tinggi [1 -1 -1], sedang [-1 1 -1], rendah [-1 -1 1]
%     Y =...
%     [1 -1 -1;
%     1 -1 -1;
%     1 -1 -1;
%     1 -1 -1;
%     -1 1 -1;
%     -1 1 -1;
%     -1 1 -1;
%     -1 -1 1;
%     -1 -1 1;
%     -1 -1 1;
%     -1 -1 1];    

    % identifikasi nilai parameter
    N = size(X,1); % banyak data
    % Note : neuron = dimensi data
    byk_dim_data_input= size(X,2); % atau byk_neuron_input_layer 
        n = byk_dim_data_input;
    %byk_neuron_hidden_layer=5 % atau byk_dim_hidden_layer
        m = byk_neuron_hidden_layer;
    byk_neuron_output_layer=size(Y,2); % atau byk_dim_data_output
    byk_data_input=size(X,1);
    %LR=0.1
    %MaxIter=10000
    %Epsilon=1e-5 % 10^(-5)
    
    % =============================================================
    % generate bobot
    % matrik bobot antara input layer dan hidden layer (V)
    % dengan random bilangan [-1,+1] atau [-5,+5]
    % beta adalah faktor skala untuk set nilai bias
    % beta=0.7*power(byk_neuron_hidden_layer,1/byk_dim_data_input)
    batas_bawah = -0.5;
    batas_atas = 0.5;
    ukuran_baris_Wjk=byk_neuron_hidden_layer;
    ukuran_kolom_Wjk=byk_dim_data_input;
    Wjk=unifinv(rand(ukuran_baris_Wjk,ukuran_kolom_Wjk),...
    batas_bawah, batas_atas);

%     Wjk=[0.0304   -0.0287   -0.0985   -0.0100   -0.0613    0.1180   -0.0674   -0.2246    0.0408    0.1016   -0.0919    0.0467
%     0.3433   -0.0395   -0.1786   -0.3792    0.2078    0.0021   -0.0730    0.2434   -0.3307    0.1074    0.0976   -0.3729
%    -0.2847    0.4425   -0.1212   -0.3601    0.0296   -0.0146   -0.4707   -0.3832    0.4301   -0.0311   -0.0743   -0.4185
%     0.2167    0.1283    0.2190    0.4472    0.1524   -0.3899    0.0104    0.2693   -0.2918    0.0963   -0.3782   -0.2105
%     0.3627    0.3064   -0.3069    0.1309    0.2782    0.4165    0.4637    0.2657   -0.4802    0.2235   -0.1500    0.1768];
    W=Wjk;
    
    InputWeight=W;
    
    % random bias
%     b=unifinv(rand(byk_neuron_hidden_layer,1),...
%     batas_bawah, batas_atas)

    % matrik bobot antara hidden layer dan output layer (Y)
    % dengan random bilangan [-1,+1] atau [-5,+5]
%     ukuran_baris_Wij=byk_neuron_output_layer;
%     ukuran_kolom_Wij=byk_neuron_hidden_layer;
%     Wij=unifinv(rand(ukuran_baris_Wij,ukuran_kolom_Wij),...
%     batas_bawah, batas_atas);

    %Beta=Wij
    
    % hitung Matrik hidden layer output (H)
    %H=Fn_Aktivasi((sum(W(1,:).*X(1,:)) + b(1)))
    %for i=1:
        
    %%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
    %InputWeight=rand(byk_neuron_hidden_layer,byk_dim_data_input)*2-1;
    % atau
    %InputWeight=rand(m,n)*2-1 % nilai ini setara dengan W
    
    BiasofHiddenNeurons=rand(1,byk_neuron_hidden_layer); % from the standard uniform distribution on the open interval (0,1)
    %BiasofHiddenNeurons=[0.6388    0.0110    0.9773    0.3855    0.3997]
    
    %tempH=W*X'; % atau tempH=X*W'
    tempH=X*W'; % ukurannya adalah byk_data_latih x byk_hidden_layer
    %clear P;                                            %   Release input of training data 
    %ind=ones(1,N);
    BiasMatrix=ones(N,1)*BiasofHiddenNeurons;         %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
    tempH=tempH+BiasMatrix;
    
    %pause (50000)
    
    %%%%%%%%%%% Calculate hidden neuron output matrix H
    %H = 1 ./ (1 + exp(-tempH))
    H =Fn_Aktivasi(tempH);
    
    
    %clear tempH;  
    
    %%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
    % OutputWeight=pinv(H') * Y % implementation without regularization factor //refer to 2006 Neurocomputing paper
    % atau 
    %format shortG
    %Hplus=inv((H'*H))*H';
    
    OutputWeight =inv((H'*H))*H'*Y; % inv((H'*H))*H' adalah Moore-Penrose as the generalized inverse 
    % OutputWeight ini setara dengan Beta_topi
    Beta_topi=OutputWeight;

    
    
    
    %OutputWeight=inv(eye(size(H,1))/C+H * H') * H * T';   % faster method 1 //refer to 2012 IEEE TSMC-B paper
    %implementation; one can set regularizaiton factor C properly in classification applications 
    %OutputWeight=(eye(size(H,1))/C+H * H') \ H * T';      % faster method 2 //refer to 2012 IEEE TSMC-B paper
    %implementation; one can set regularizaiton factor C properly in classification applications

    %If you use faster methods or kernel method, PLEASE CITE in your paper properly: 

    %Guang-Bin Huang, Hongming Zhou, Xiaojian Ding, and Rui Zhang, "Extreme Learning Machine for Regression and Multi-Class Classification," submitted to IEEE Transactions on Pattern Analysis and Machine Intelligence, October 2010. 


    %% %%%%%%%%% Calculate the training accuracy
    Y_predict=(H * Beta_topi);                             %   Y: the actual output of the training data
    Result = Y_predict;
    %pause(50000000);
%     [Y round(Y_predict) Y_predict]
%     TrainingAccuracy=sqrt(mse(Y - round(Y_predict)))  %   Calculate training accuracy (RMSE) for regression case
%     sqrt(sum((Y - Y_predict).*(Y - round(Y_predict)))/N)
%     %if Elm_Type == REGRESSION
%     %    TrainingAccuracy=sqrt(mse(Y - Y_predict))               %   Calculate training accuracy (RMSE) for regression case
%     %end
%     %clear H;
%     
%     %% Proses Testing Algoritma ELM
%     %% %%%%%%%%% Calculate the output of testing input
%     
% %     Xtest=...
% %         [3 3 2; % Data ke-1
% %         3 2 2;  % Data ke-2
% %         3 2 1;  % Data ke-3
% %         3 1 1;  % 4
% %         2 3 2;  % 5
% %         2 2 2;  % 6
% %         2 2 1;  % 7
% %         2 1 1;  % 8
% %         1 3 2;  % 9
% %         1 2 1;  % 10
% %         1 1 2]  % Data ke-n
% % 
% %      
% %         Ytest =...
% %         [1 -1 -1;
% %         1 -1 -1;
% %         1 -1 -1;
% %         1 -1 -1;
% %         -1 1 -1;
% %         -1 1 -1;
% %         -1 1 -1;
% %         -1 -1 1;
% %         -1 -1 1;
% %         -1 -1 1;
% %         -1 -1 1];
%     
%        % modif Y
%        %Ytest=[Ytest Ytest Ytest]
%        
%        % Data kelas Aktual Xtest
% %        kelas_aktual=[1;
% %         1;
% %         1;
% %         1;
% %         2;
% %         2;
% %         2;
% %         3;
% %         3;
% %         3;
% %         3];
%     [vMaxa,idxMaxa]=max(Ytest');
%     kelas_aktual=idxMaxa';
%     
%     byk_data_test=size(Xtest,1);
%     %tempH_test=InputWeight*Xtest';
%     tempH_test=Xtest*W';
%     %ind=ones(1,byk_data_test);
%     %BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
%     % atau cara lain
%     BiasMatrix=(ones(byk_data_test,1))*BiasofHiddenNeurons; %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
%     tempH_test=tempH_test + BiasMatrix;
%     
%     %H_test = 1 ./ (1 + exp(-tempH_test))
%     H_test =Fn_Aktivasi(tempH_test)
%     
%     %   TY: output of the testing data (Y_test_predict)
%     Ytest_predict=(H_test * Beta_topi)
%     [vMax,idxMax]=max(Ytest_predict');
%     kelas_prediksi=idxMax';
%     
%     % [kelas_aktual kelas_prediksi]
%     nBenar=numel(find(kelas_aktual-kelas_prediksi==0));
%     akurasi=(nBenar/byk_data_test)*100
%     Result=akurasi
    
    
    