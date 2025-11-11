package com.example.renewal_firstclass.config;

import javax.sql.DataSource;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;



@Configuration
@ComponentScan(basePackages = {
  "com.example.renewal_firstclass.service",
  "com.example.renewal_firstclass.batch",
  "com.example.renewal_firstclass.scheduler"
})
@EnableScheduling               // @Scheduled 작동
@EnableBatchProcessing          // JobRepository/JobLauncher/JBF/SBF 생성
@MapperScan("com.example.renewal_firstclass.dao")
public class RootConfig {

  @Bean
  public DataSource dataSource() {
    org.apache.commons.dbcp2.BasicDataSource ds = new org.apache.commons.dbcp2.BasicDataSource();
    ds.setDriverClassName("oracle.jdbc.OracleDriver");
    ds.setUrl("jdbc:oracle:thin:@//HOST:1521/ORCLPDB1"); // 실제 값으로
    ds.setUsername("USER"); ds.setPassword("PASS");
    ds.setInitialSize(3); ds.setMaxTotal(20);
    return ds;
  }

  @Bean
  public org.springframework.transaction.PlatformTransactionManager transactionManager(DataSource ds) {
    return new org.springframework.jdbc.datasource.DataSourceTransactionManager(ds);
  }

  // MyBatis 설정(매퍼 XML 경로)
  @Bean
  public org.apache.ibatis.session.SqlSessionFactory sqlSessionFactory(DataSource ds) throws Exception {
    org.mybatis.spring.SqlSessionFactoryBean fb = new org.mybatis.spring.SqlSessionFactoryBean();
    fb.setDataSource(ds);
    fb.setTypeAliasesPackage("com.example.renewal_firstclass.domain");
    fb.setMapperLocations(new org.springframework.core.io.support.PathMatchingResourcePatternResolver()
      .getResources("classpath*:mapper/*.xml"));
    return fb.getObject();
  }

  @Bean
  public org.mybatis.spring.SqlSessionTemplate sqlSessionTemplate(org.apache.ibatis.session.SqlSessionFactory f) {
    return new org.mybatis.spring.SqlSessionTemplate(f);
  }
}
