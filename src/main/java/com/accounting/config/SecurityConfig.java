package com.accounting.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.security.web.servlet.util.matcher.MvcRequestMatcher;
import org.springframework.web.servlet.handler.HandlerMappingIntrospector;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, HandlerMappingIntrospector introspector) throws Exception {
        MvcRequestMatcher.Builder mvcMatcherBuilder = new MvcRequestMatcher.Builder(introspector);
        
        http
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                .invalidSessionUrl("/login?invalid")
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false)
                .expiredUrl("/login?expired")
            )
            .csrf(csrf -> csrf
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                .ignoringRequestMatchers(
                    mvcMatcherBuilder.pattern("/static/**"),
                    mvcMatcherBuilder.pattern("/css/**"),
                    mvcMatcherBuilder.pattern("/js/**"),
                    mvcMatcherBuilder.pattern("/images/**"),
                    mvcMatcherBuilder.pattern("/fonts/**"),
                    mvcMatcherBuilder.pattern("/resources/**"),
                    mvcMatcherBuilder.pattern("/kiosk/verify-student"),
                    mvcMatcherBuilder.pattern("/kiosk/payment/*/process")
                )
            )
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(
                    mvcMatcherBuilder.pattern("/static/**"),
                    mvcMatcherBuilder.pattern("/css/**"),
                    mvcMatcherBuilder.pattern("/js/**"),
                    mvcMatcherBuilder.pattern("/images/**"),
                    mvcMatcherBuilder.pattern("/fonts/**"),
                    mvcMatcherBuilder.pattern("/resources/**")
                ).permitAll()
                .requestMatchers(
                    mvcMatcherBuilder.pattern("/login"),
                    mvcMatcherBuilder.pattern("/register"),
                    mvcMatcherBuilder.pattern("/forgot-password")
                ).permitAll()
                .requestMatchers(mvcMatcherBuilder.pattern("/WEB-INF/jsp/**")).permitAll()
                .requestMatchers(
                    mvcMatcherBuilder.pattern("/kiosk/**"),
                    mvcMatcherBuilder.pattern("/accounting/kiosk/**")
                ).permitAll()
                .requestMatchers(mvcMatcherBuilder.pattern("/admin/**")).hasRole("ADMIN")
                .requestMatchers(mvcMatcherBuilder.pattern("/manager/**")).hasRole("MANAGER")
                .requestMatchers(mvcMatcherBuilder.pattern("/user/**")).hasRole("USER")
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                .successHandler(authenticationSuccessHandler())
                .failureUrl("/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .addLogoutHandler((request, response, authentication) -> {
                    log.info("Logout initiated for user: {}", authentication != null ? authentication.getName() : "unknown");
                })
                .logoutSuccessHandler((request, response, authentication) -> {
                    log.info("Logout successful for user: {}", authentication != null ? authentication.getName() : "unknown");
                    response.sendRedirect(request.getContextPath() + "/login?logout=true");
                })
                .permitAll()
            )
            .sessionManagement(session -> session
                .sessionFixation().changeSessionId()
            );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new SimpleUrlAuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                    Authentication authentication) throws IOException, ServletException {
                clearAuthenticationAttributes(request);
                String targetUrl = determineTargetUrl(authentication);
                if (response.isCommitted()) {
                    log.debug("Response has already been committed. Unable to redirect to {}", targetUrl);
                    return;
                }
                getRedirectStrategy().sendRedirect(request, response, targetUrl);
            }

            protected String determineTargetUrl(Authentication authentication) {
                for (GrantedAuthority authority : authentication.getAuthorities()) {
                    if (authority.getAuthority().equals("ROLE_ADMIN")) {
                        return "/admin/dashboard";
                    } else if (authority.getAuthority().equals("ROLE_MANAGER")) {
                        return "/manager/dashboard";
                    } else if (authority.getAuthority().equals("ROLE_USER")) {
                        return "/user/dashboard";
                    }
                }
                return "/login";
            }
        };
    }

    @Bean
    public HttpFirewall allowUrlEncodedSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedSlash(true);
        firewall.setAllowSemicolon(true);
        firewall.setAllowBackSlash(false);
        firewall.setAllowUrlEncodedDoubleSlash(true);
        return firewall;
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.httpFirewall(allowUrlEncodedSlashHttpFirewall());
    }
} 