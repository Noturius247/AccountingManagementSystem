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
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                .invalidSessionUrl("/login?invalid")
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false)
                .expiredUrl("/login?expired")
            )
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/css/**", "/js/**", "/images/**", "/fonts/**", "/static/**", "/resources/**")
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
            )
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/css/**", "/js/**", "/images/**", "/fonts/**", "/static/**", "/resources/**").permitAll()
                .requestMatchers("/login", "/register", "/forgot-password").permitAll()
                .requestMatchers("/WEB-INF/jsp/**").permitAll()
                .requestMatchers("/kiosk/**", "/accounting/kiosk/**", "/kiosk", "/accounting/kiosk").permitAll()
                .requestMatchers("/kiosk/payment/**", "/accounting/kiosk/payment/**").permitAll()
                .requestMatchers("/kiosk/queue/**", "/accounting/kiosk/queue/**").permitAll()
                .requestMatchers("/kiosk/help/**", "/accounting/kiosk/help/**").permitAll()
                .requestMatchers("/kiosk/search/**", "/accounting/kiosk/search/**").permitAll()
                .requestMatchers("/kiosk/verify-student/**", "/accounting/kiosk/verify-student/**").permitAll()
                .requestMatchers("/kiosk/payment/*/process", "/accounting/kiosk/payment/*/process").permitAll()
                .requestMatchers("/admin/**", "/admin/**").hasRole("ADMIN")
                .requestMatchers("/manager/**", "/manager/**").hasRole("MANAGER")
                .requestMatchers("/user/**", "/user/**").hasRole("USER")
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