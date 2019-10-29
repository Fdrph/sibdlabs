DROP TABLE carreira;
DROP TABLE comissao;
DROP TABLE empregado;
DROP TABLE departamento CASCADE CONSTRAINTS;
DROP TABLE categoria;



CREATE TABLE categoria (
	codigo 			NUMBER(3),
	designacao 		VARCHAR2(40)	CONSTRAINT nn__categoria_designacao 	NOT NULL,
	salario_base	NUMBER(6,2) 	CONSTRAINT nn__categoria_salario_base 	NOT NULL,

	CONSTRAINT pk_categoria
		PRIMARY KEY (codigo),
		
	CONSTRAINT un_categoria_designacao
		UNIQUE (designacao),
		
	CONSTRAINT ck_categoria_codigo
		CHECK (codigo > 0),
	
	CONSTRAINT categoria_salario_base
		CHECK (salario_base > 0.0)
);

CREATE TABLE departamento (
	codigo 		NUMBER(3),
	nome 		VARCHAR2(40) CONSTRAINT nn__departamento_nome 		NOT NULL,
	localizacao VARCHAR2(40) CONSTRAINT nn_departamento_localizacao NOT NULL,
	diretor		CONSTRAINT nn_departamento_diretor					NOT NULL,
	
	CONSTRAINT pk_departamento
		PRIMARY KEY (codigo),
	
	CONSTRAINT ck_departamento_codigo
		CHECK (codigo > 0),
	
	CONSTRAINT un_departamento_nome
		UNIQUE (nome),
	
	CONSTRAINT fk_departamento_diretor
		FOREIGN KEY (diretor) REFERENCES empregado(numero),
	
	CONSTRAINT un_departamento_diretor
		UNIQUE (diretor),
);

CREATE TABLE empregado (
	numero 			NUMBER(5),
	nome			VARCHAR2(40) NOT NULL,
	categoria 		NOT NULL,
	departamento	CONSTRAINT nn_empregado_departamento NOT NULL,
	chefe			NOT NULL,
	
	CONSTRAINT pk_empregado
		PRIMARY KEY (numero),
	CONSTRAINT fk_empregado_categoria
		FOREIGN KEY (categoria) 	REFERENCES categoria(codigo),
	CONSTRAINT fk_empregado_departamento
		FOREIGN KEY (departamento) 	REFERENCES departamento(codigo),
	CONSTRAINT fk_empregado_chefe
		FOREIGN KEY (chefe)			REFERENCES empregado(numero),
	CONSTRAINT ck_empregado_numero
		CHECK (numero > 0),
	CONSTRAINT ck_empregado_chefe_numero
		CHECK ((chefe <> numero) OR (numero = 1)),
);

CREATE TABLE comissao (
	empregado,
	data DATE,
	valor NUMBER(6,2) NOT NULL,
	
	PRIMARY KEY (empregado,data),
	FOREIGN KEY (empregado) REFERENCES empregado(numero) ON DELETE CASCADE,
	CHECK (valor > 0.0),

);

CREATE TABLE carreira (
	empregado,
	categoria,
	data_admissao DATE NOT NULL,
);

INSERT INTO categoria (codigo, designacao, salario_base)
	VALUES (100, 'Presidente', 3000.30);
	
INSERT INTO categoria (codigo, designacao, salario_base)
	VALUES (200, 'Diretor', 2000.20);
	
INSERT INTO categoria (codigo, designacao, salario_base)
	VALUES (300, 'Consultor', 1000.10);