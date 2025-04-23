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
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.view.ContentNegotiatingViewResolver;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.accept.ContentNegotiationStrategy;
import org.springframework.web.accept.HeaderContentNegotiationStrategy;
import org.springframework.web.accept.ParameterContentNegotiationStrategy;
import org.springframework.http.MediaType;
import org.springframework.context.annotation.Primary;
import java.util.List;
import java.util.Properties;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("file:src/main/webapp/static/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("file:src/main/webapp/resources/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        registry.addResourceHandler("/css/**")
                .addResourceLocations("file:src/main/webapp/static/css/")
                .setCachePeriod(3600)
                .resourceChain(true);
                
        registry.addResourceHandler("/js/**")
                .addResourceLocations("file:src/main/webapp/static/js/")
                .setCachePeriod(3600)
                .resourceChain(true);
    }

    @Bean
    @Primary
    public ContentNegotiationManager contentNegotiationManager() {
        Map<String, MediaType> mediaTypes = new HashMap<>();
        mediaTypes.put("json", MediaType.APPLICATION_JSON);
        mediaTypes.put("xml", MediaType.APPLICATION_XML);
        mediaTypes.put("html", MediaType.TEXT_HTML);
        
        return new ContentNegotiationManager(
            new HeaderContentNegotiationStrategy(),
            new ParameterContentNegotiationStrategy(mediaTypes)
        );
    }

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(JstlView.class);
        resolver.setOrder(1);
        resolver.setViewNames("*");
        return resolver;
    }

    @Bean
    public MappingJackson2JsonView jsonView() {
        MappingJackson2JsonView jsonView = new MappingJackson2JsonView();
        jsonView.setPrettyPrint(true);
        return jsonView;
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

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.setUseTrailingSlashMatch(true);
        configurer.setUseSuffixPatternMatch(false);
    }
} 