package com.example.renewal_firstclass.batch;

import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class BatchFactoriesConfig {

    @Bean
    public JobBuilderFactory jobBuilderFactory(JobRepository jobRepository) {
        return new JobBuilderFactory(jobRepository);
    }

    @Bean
    public StepBuilderFactory stepBuilderFactory(JobRepository jobRepository,
                                                 PlatformTransactionManager transactionManager) {
        return new StepBuilderFactory(jobRepository, transactionManager);
    }
}
