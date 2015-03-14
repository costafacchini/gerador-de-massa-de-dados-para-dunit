# gerador-de-massa-de-dados-para-dunit

Desenvolvido em Delphi XE.

Este aplicativo tem como objetivo gerar um arquivo com instruções SQL para ser utilizado em testes do DUnit.
O arquivo com as duas instruções podem ser gerados em dois formatos. 
 - O primeiro formato é com instruções de Insert. O campo fica na linha de cima e o valor na debaixo. 
   Ex: insert into teste (codigo,    nome)
                  values (     1, 'Teste');
                  
 - O segundo formato é com instruções Update. O campo fica na mesma linha que o valor.
   Ex: update teste
       set
          nome = 'Teste'
       where
         codigo = 1;
