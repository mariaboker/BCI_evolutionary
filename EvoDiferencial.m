%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%   Evolucao Diferencial aplicado a Imaginacao do Movimento BCI          %
%                                                                        %
%   TCC 2019															 %
%   Maria B Kersanach, RA 156571                                         %
%   Romis R F Attux DCA FEEC UNICAMP                                     %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clear all;

close all;


sujeito = '156571_20161107';

[H, vrotulos] = trataSinais(sujeito);

%% parametros da interface
numAtrib = 16;  % 20 atributos a serem selecionados = 16 eletrodos + 4 bandas
tamPop = 20; 	% tamanho da populacao

Nit = 100; % numero de iteracoes

CR = 0.5;				% propabilidade de crossover
F = 0.7;				% fator multiplicativo da mutacao

% garantir que tamPop eh par
if mod(tamPop,2) > 0
    tamPop = tamPop+1;
end

% Gera populacao inicial de pais (vetores binarios aleatorios)
populacao = randi([0 1], tamPop, numAtrib); 	% matriz populacao com atributos 0s e 1s 


for it = 1:Nit
	for x1 = 1:tamPop % para cada individuo da populacao 

		% Indice que representa o individuo na populacao
		x2 = randi(tamPop);		% Indice individuo 2 escolhido aleatoriamente
		x3 = randi(tamPop);     % Indice individuo 3 escolhido aleatoriamente

        % MUTACAO
        % v vetor de 20 posicoes com valores nao necessariamente binarios gerados pela funcao:
        v = populacao(x1,:) + F * (populacao(x2,:) - populacao(x3,:));
        
        % ainda para o mesmo individuo
		for j = 1:numAtrib
			
			% CROSSOVER UNIFORME com individuo mutado v
			r1 = rand;						% [0,1] prob de crossover para o individuo
			r2 = randi(numAtrib);			% parametro para garantir que pelo menos um dos elementos vai ser do individuo v
			
			if or(r1 <= CR, j == r2)		% bit do individuo mutado selecionado 
				u(j) = v(j);

            else	% bit do individuo original selecionado (sem mutacao)
				u(j) = populacao(x1,j); 

            end

            u = 0.5*(sign(u-0.5)) + 0.5; % BINARIZAÇÃO - funcao sign retorna 0 se negativo e 1 se positivo
			
        end
        
        % COMPETICAO SIMPLES - selecao
        [fitu, ~] = fit( H, vrotulos, u);
        [fitpopulacao,~] = fit( H, vrotulos, populacao(x1,:));
			if fitu >= fitpopulacao
				populacao(x1,:) = u;		% individuo intermediario criado eh selecionado para substituir original
			end
    end
    
    [fitness_atual,Erro] = fit( H, vrotulos, populacao);
    
    fitness_max(it) = max(fitness_atual);
    fitness_medio(it) = mean(fitness_atual);
    
    ErroGeracoes(it) = mean(Erro);
    ErrominGer(it) = min(Erro);
    
end


figure(1)
plot(fitness_max);
hold on
plot(fitness_medio,'r')

plot(ErroGeracoes, 'k');
hold on;
plot(ErrominGer, 'g');
hold on;

