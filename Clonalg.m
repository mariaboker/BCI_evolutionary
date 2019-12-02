%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%   CLONALG aplicado a Imaginacao do Movimento BCI                       %
%                                                                        %
%   Maria B Kersanach, RA 156571                                         %
%   Romis R F Attux DCA FEEC UNICAMP                                     %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clear all;

close all;

global EQM_pop;

sujeito = '156571_20161107';

[H, vrotulos] = trataSinais(sujeito);

%% parametros da interface
numAtrib = 16;   % 20 atributos a serem selecionados = 16 eletrodos + 4 bandas
tamPop = 20;     % tamanho da populacao
numCopias = 5;  % numero de copias que sofrerao mutacao para disputar o local na populacao

numIt = 150; % numero de vezes que acontecera o refinamento dos individuos por mutacao
numSubst = 0.3 * tamPop; % numero de individuos a serem substituidos por novos aleatorios
numRefina = 20; % numero de iteracoes ate a inclusao de novos individuos

ro = 3; % parametro do auto ajuste da mutacao

% garantir que tamPop eh par
if mod(tamPop,2) > 0
    tamPop = tamPop + 1;
end

% Gera populacao inicial de pais (vetores binarios aleatorios)
populacao = randi([0 1], tamPop, numAtrib); % matriz populacao com atributos 0s e 1s 

	for it = 1:numIt

		fitness = []; % inicializa o vetor de fitness da populacao zerado

		for atual = 1:tamPop
			for k = 1:numCopias % cria uma matriz com copias do individuo
				amostragem(k, :) = populacao(atual, :);
            end
            populacao(atual,:);
            [fitness_amostragem, ~] = fit(H, vrotulos, populacao);
            
			%% MUTACAO
			mascMut = rand(numCopias-1, numAtrib); 	% cria matriz aleatoria com probabilidades de cada atributo sofrer mutacao

			% percorre a matriz procurando posicoes onde ocorrera mutacao
			for k = 1:(numCopias-1) % mantem o ultimo como o original
				for kk = 1:numAtrib
					if mascMut(k, kk) <= exp(-ro*fitness_amostragem) 	% ocorre mutacao com AUTO AJUSTE DA MUTAÇÃO - EQUAÇÃO (6) DO PAPER
						amostragem(k, kk) = 1 - amostragem(k, kk); % realiza a MUTACAO
					end
				end
		    end

			% retorna o maior fitness e o indice onde ele se encontra no vetor gerado pela funcao fit nos individuos da amostragem
			[fiti, Erro] = fit(H, vrotulos, amostragem);
			[maior_fit, indice_maior] = max(fiti, [], 2);

			populacao(atual,:) = amostragem(indice_maior,:); % substitui o individuo original pelo que teve maior fitness 
            
            fitness = [fitness; maior_fit]; % guarda os melhores fitness de cada iteracao

		end

		 % guarda o melhor fitness de cada iteraÃ§Ã£o na populacao inteira
    
    [fitness,indices] = sortrows(fitness); 	% ordena os fitness da populacao
	populacao = populacao(indices,:);       % reordena a matriz populacao em ordem crescente de fitness

    if mod (it, numRefina) == 0
		% substitui os "numSubst" individuos com menores fitness por novos aleatorios
		populacao(1:numSubst,:) = randi([0 1], numSubst, numAtrib); % matriz populacao com atributos 0s e 1s   VERIFICAR SE Ã‰ ASSIM !!!!!!!!!!!! DEI UMA MEXIDA
    
    end
    
    fitness_max(it) = max(fitness);
    fitness_medio(it) = mean(fitness);
    
    ErroGeracoes(it) = mean(Erro);
    ErrominGer(it) = min(Erro);
        
    EQMminGeracoes(it) = min(EQM_pop);
    
    end
    
EQMminGeracoes(numIt)
    
figure(1)
plot(fitness_max)
hold on
plot(fitness_medio,'r')

plot(ErroGeracoes, 'k');
hold on;
plot(ErrominGer, 'g');
hold on;
    
    
    
