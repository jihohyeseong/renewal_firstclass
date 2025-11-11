package com.example.renewal_firstclass.batch;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.renewal_firstclass.service.ApprovalBatchService;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class ConfirmJobConfig {
	
    private final JobBuilderFactory jobBuilderFactory;
    private final StepBuilderFactory stepBuilderFactory;
    private final ApprovalBatchService approvalBatchService;

    @Bean
    public Job confirmAutoApproveJob() {
        return jobBuilderFactory.get("confirmAutoApproveJob")
                .start(autoApproveStep())
                .build();
    }

    @Bean
    public Step autoApproveStep() {
        return stepBuilderFactory.get("autoApproveStep")
                .tasklet((contribution, chunkContext) -> {
                    int updated = approvalBatchService.approveConfirmByBatch();
                    System.out.println("[BATCH] auto approve updated: " + updated);
                    return RepeatStatus.FINISHED;
                })
                .build();
    }
}