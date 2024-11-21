#Criando o banco de dados
CREATE SCHEMA IF NOT EXISTS INOVA_TECH; 
USE INOVA_TECH; 

#Criando a tabela CLIENTES
CLIENTES CREATE TABLE IF NOT EXISTS CLIENTES( 
CPF_CLIENTE INT AUTO_INCREMENT PRIMARY KEY,
CLIENTE_NOME VARCHAR(100) NOT NULL,
CLIENTE_DATA_NASC DATE NOT NULL,
CLIENTE_EMAIL VARCHAR(100) NOT NULL,
CLIENTE_TELEFONE VARCHAR(20) NOT NULL,
ID_ENDERECO INT,
CONSTRAINT FK_CLIENTE_ENDERECO FOREIGN KEY (ID_ENDERECO) REFERENCES ENDERECOS(ID_ENDERECO)
);

#Criando a tabela FORNECEDORES 
CREATE TABLE IF NOT EXISTS FORNECEDORES(
FORNECE_ID INT AUTO_INCREMENT PRIMARY KEY,
FORNECE_NOME VARCHAR(100) NOT NULL,
FORNECE_CNPJ VARCHAR(20) NOT NULL,
FORNECE_EMAIL VARCHAR(100) NOT NULL,
FORNECE_TELEFONE VARCHAR(20) NOT NULL,
FORNECE_TIPO_PROD VARCHAR(100) NOT NULL,
ID_ENDERECO INT,
CONSTRAINT FK_FORNECE_ENDERECO FOREIGN KEY (ID_ENDERECO) REFERENCES ENDERECOS(ID_ENDERECO)
);

#Criando a tabela VENDAS 
CREATE TABLE IF NOT EXISTS VENDAS(
VENDA_ID INT AUTO_INCREMENT PRIMARY KEY,
CPF_CLIENTE INT NOT NULL,
VENDA_DATA DATE NOT NULL,
CONSTRAINT FK_CPF_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTES(CPF_CLIENTE)
);

#Criando a tabela PRODUTOS 
CREATE TABLE IF NOT EXISTS PRODUTOS(
PROD_ID INT AUTO_INCREMENT PRIMARY KEY,
PROD_NOME VARCHAR(100) NOT NULL,
PROD_DESCRICAO VARCHAR(200) NOT NULL,
PROD_CATEGORIA VARCHAR(100) NOT NULL,
PROD_PRECO DECIMAL(10,2) NOT NULL,
PROD_QUANTI_ESTOQUE DECIMAL NOT NULL,
FORNECE_ID INT NOT NULL,
CONSTRAINT FK_FORNECEP_ID FOREIGN KEY (FORNECE_ID) REFERENCES FORNECEDORES(FORNECE_ID)
); 

#Criando a tabela PRODUTOS_VENDAS
CREATE TABLE IF NOT EXISTS PRODUTOS_VENDAS(
VENDA_ID INT,
PROD_ID INT,
PRIMARY KEY (VENDA_ID, PROD_ID),
PDVD_VALOR_UNIT DECIMAL(10,2) NOT NULL,
PDVD_QUANTIDADE INT NOT NULL,
CONSTRAINT FK_VENDA_ID FOREIGN KEY (VENDA_ID) REFERENCES VENDAS(VENDA_ID),
CONSTRAINT FK_PROD_ID FOREIGN KEY (PROD_ID) REFERENCES PRODUTOS(PROD_ID) 
);

#Criando a tabela PAGAMENTOS 
CREATE TABLE IF NOT EXISTS PAGAMENTOS(
PAGA_ID INT AUTO_INCREMENT PRIMARY KEY,
PAGA_VALOR DECIMAL(10,2) NOT NULL,
PAGA_DATA DATE NOT NULL,
CPF_CLIENTE INT NOT NULL, 
VENDA_ID INT NOT NULL, 
CONSTRAINT FK_CPF_CLIENTEP FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTES(CPF_CLIENTE),
CONSTRAINT FK_VENDAP_ID FOREIGN KEY (VENDA_ID) REFERENCES VENDAS(VENDA_ID)
);

#Criando a tabela ENDERECOS
CREATE TABLE IF NOT EXISTS ENDERECOS(
ID_ENDERECO INT AUTO_INCREMENT PRIMARY KEY,
RUA VARCHAR(100) NOT NULL,
NUMERO INT,
BAIRRO VARCHAR(100) NOT NULL,
CIDADE VARCHAR(100) NOT NULL,
ESTADO VARCHAR(2) NOT NULL,
CEP VARCHAR(14) NOT NULL
);

ALTER TABLE CLIENTES ADD COLUMN CLIENTE_RG VARCHAR(20);
ALTER TABLE CLIENTES MODIFY CLIENTE_TELEFONE VARCHAR(15) NOT NULL;
ALTER TABLE CLIENTES DROP COLUMN CLIENTE_STATUS; 
ALTER TABLE CLIENTES ADD CONSTRAINT UNIQUE_EMAIL UNIQUE (CLIENTE_EMAIL);

ALTER TABLE FORNECEDORES ADD COLUMN FORNECE_WEBSITE VARCHAR(100); 
ALTER TABLE FORNECEDORES MODIFY FORNECE_TELEFONE VARCHAR(15) NOT NULL; 
ALTER TABLE FORNECEDORES DROP COLUMN FORNECE_TIPO_PROD; 
ALTER TABLE FORNECEDORES ADD CONSTRAINT UNIQUE_CNPJ UNIQUE (FORNECE_CNPJ);

ALTER TABLE VENDAS ADD COLUMN VENDA_VALOR_TOTAL DECIMAL(10, 2);
ALTER TABLE VENDAS MODIFY VENDA_DATA DATETIME NOT NULL;
ALTER TABLE VENDAS DROP CONSTRAINT FK_CPF_CLIENTE;
ALTER TABLE VENDAS ADD CONSTRAINT FK_NOVO_CLIENTE FOREIGN KEY (CPF_CLIENTE) REFERENCES CLIENTES(CPF_CLIENTE);

ALTER TABLE PRODUTOS ADD COLUMN PROD_IMAGEM_URL VARCHAR(255);
ALTER TABLE PRODUTOS MODIFY PROD_QUANTI_ESTOQUE INT NOT NULL;
ALTER TABLE PRODUTOS DROP COLUMN PROD_DESCRICAO;
ALTER TABLE PRODUTOS ADD CONSTRAINT UNIQUE_NOME UNIQUE (PROD_NOME);

ALTER TABLE PRODUTOS_VENDAS ADD COLUMN DATA_VENDA DATE;
ALTER TABLE PRODUTOS_VENDAS MODIFY PDVD_QUANTIDADE DECIMAL(10, 3) NOT NULL;
ALTER TABLE PRODUTOS_VENDAS DROP CONSTRAINT FK_VENDA_ID;
ALTER TABLE PRODUTOS_VENDAS ADD CONSTRAINT FK_NOVA_VENDA_ID FOREIGN KEY (VENDA_ID) REFERENCES VENDAS(VENDA_ID);

ALTER TABLE PAGAMENTOS ADD COLUMN PAGA_METODO VARCHAR(50);
ALTER TABLE PAGAMENTOS MODIFY PAGA_STATUS ENUM('PAGO', 'PENDENTE', 'CANCELADO');
ALTER TABLE PAGAMENTOS DROP CONSTRAINT FK_VENDAP_ID;
ALTER TABLE PAGAMENTOS ADD CONSTRAINT FK_NOVO_VENDA_ID FOREIGN KEY (VENDA_ID) REFERENCES VENDAS(VENDA_ID);

ALTER TABLE ENDERECOS ADD COLUMN COMPLEMENTO VARCHAR(50);
ALTER TABLE ENDERECOS MODIFY NUMERO VARCHAR(10);
ALTER TABLE ENDERECOS DROP COLUMN CEP;
ALTER TABLE ENDERECOS ADD CONSTRAINT UNIQUE_ENDERECO UNIQUE (RUA, NUMERO, BAIRRO, CIDADE, ESTADO);

DROP DATABASE INOVA_TECH;