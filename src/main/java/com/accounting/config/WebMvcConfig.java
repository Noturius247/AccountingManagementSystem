package com.accounting.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import java.util.List;
import java.util.Properties;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("file:src/main/webapp/static/")
                .setCachePeriod(3600)
                .resourceChain(true);
    }

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        return resolver;
    }

    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }

    @Override
    public void configureMessageConverters(List<org.springframework.http.converter.HttpMessageConverter<?>> converters) {
        converters.add(new MappingJackson2HttpMessageConverter());
        converters.add(new StringHttpMessageConverter());
    }

    @Bean
    public SimpleMappingExceptionResolver exceptionResolver() {
        SimpleMappingExceptionResolver resolver = new SimpleMappingExceptionResolver();
        resolver.setDefaultErrorView("error");
        
        Properties mappings = new Properties();
        mappings.setProperty("java.lang.Exception", "error");
        mappings.setProperty("org.springframework.web.servlet.NoHandlerFoundException", "404");
        mappings.setProperty("org.springframework.security.access.AccessDeniedException", "403");
        resolver.setExceptionMappings(mappings);
        
        Properties statusCodes = new Properties();
        statusCodes.setProperty("error", "500");
        statusCodes.setProperty("404", "404");
        statusCodes.setProperty("403", "403");
        resolver.setStatusCodes(statusCodes);
        
        return resolver;
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        // We're handling static resources through our resource handlers
        // No need for default servlet handling
    }
} 