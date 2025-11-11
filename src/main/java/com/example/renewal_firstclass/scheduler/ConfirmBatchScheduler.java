package com.example.renewal_firstclass.scheduler;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ConfirmBatchScheduler {

    private final JobLauncher jobLauncher;
    private final Job confirmAutoApproveJob;

    // 매일 새벽 03:00 (KST)
    @Scheduled(cron = "0 0 3 * * *", zone = "Asia/Seoul")
    public void run() throws Exception {
        jobLauncher.run(
                confirmAutoApproveJob,
                new JobParametersBuilder()
                        .addLong("ts", System.currentTimeMillis())
                        .toJobParameters()
        );
    }
}