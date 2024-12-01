package com.liveteam.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class Tabelas {

    public static void main(String[] args) {
        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement()) {

            // Criação da tabela de usuários
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS usuario (" +
                    "id SERIAL PRIMARY KEY, " +
                    "nome VARCHAR(50) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "senha VARCHAR(255) NOT NULL)");

            System.out.println("Tabela 'usuario' criada com sucesso!");

            // Criação da tabela de dados diários
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS dados_diarios (" +
                    "id SERIAL PRIMARY KEY, " +
                    "id_usuario INT NOT NULL, " + // Relacionamento com a tabela usuario
                    "dia INT NOT NULL, " +
                    "mes INT NOT NULL, " +
                    "ano INT NOT NULL, " +
                    // Alimentação
                    "cafe_da_manha TEXT, " +
                    "almoco TEXT, " +
                    "jantar TEXT, " +
                    "lanches TEXT, " +
                    "observacoes_alimentacao TEXT, " +
                    // Líquidos
                    "agua VARCHAR(255), " +
                    "outros_liquidos VARCHAR(255), " +
                    "observacoes_liquidos TEXT, " +
                    // Exercícios
                    "tipo_treino VARCHAR(255), " +
                    "duracao_treino VARCHAR(255), " +
                    "intensidade_treino VARCHAR(255), " +
                    "detalhes_exercicio TEXT, " +
                    "observacoes_exercicio TEXT, " +
                    // Avaliação pessoal
                    "nivel_fome VARCHAR(255), " +
                    "nivel_energia VARCHAR(255), " +
                    "qualidade_sono VARCHAR(255), " +
                    "observacoes_avaliacao TEXT, " +
                    // Relacionamento com chave estrangeira
                    "FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE)");

            System.out.println("Tabela 'dados_diarios' criada com sucesso!");

            // Criação da tabela de plano de dieta e treino
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS plano_dieta_treino (" +
                    "id SERIAL PRIMARY KEY, " +
                    // Dados Pessoais
                    "idade INT NOT NULL, " +
                    "sexo VARCHAR(20) NOT NULL, " +
                    "altura_cm DECIMAL(5, 2) NOT NULL, " +
                    "peso_kg DECIMAL(5, 2) NOT NULL, " +
                    "objetivo_principal TEXT NOT NULL, " +
                    // Nível de Atividade Física
                    "frequencia_semanal_treino INT NOT NULL, " +
                    "duracao_media_treino_minutos INT NOT NULL, " +
                    "tipo_atividade_fisica TEXT NOT NULL, " +
                    "objetivos_treino TEXT NOT NULL, " +
                    // Hábitos Alimentares Culturais
                    "nacionalidade VARCHAR(100) NOT NULL, " +
                    "residencia_atual VARCHAR(255) NOT NULL, " +
                    // Preferências Alimentares e Restrições
                    "alimentos_favoritos TEXT, " +
                    "alimentos_que_evita TEXT, " +
                    "alimentos_para_incluir_excluir TEXT, " +
                    // Suplementação
                    "usa_suplementos BOOLEAN NOT NULL, " +
                    "suplementos_usados TEXT, " +
                    // Tempo Disponível para o Treino
                    "tempo_por_treino_minutos INT NOT NULL, " +
                    // Cardápio Diário
                    "cafe_da_manha TEXT, " +
                    "almoco TEXT, " +
                    "lanche_tarde TEXT, " +
                    "jantar TEXT, " +
                    // Datas e Referências
                    "data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            System.out.println("Tabela 'plano_dieta_treino' criada com sucesso!");

        } catch (SQLException e) {
            System.err.println("Erro ao executar comandos SQL: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection();
        }
    }
}
