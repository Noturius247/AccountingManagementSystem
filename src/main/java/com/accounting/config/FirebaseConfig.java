package com.accounting.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;

import java.io.IOException;

@Configuration
@ConditionalOnProperty(name = "app.firebase.enabled", havingValue = "true", matchIfMissing = false)
public class FirebaseConfig {

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        if (FirebaseApp.getApps().isEmpty()) {
            try {
                GoogleCredentials credentials = GoogleCredentials.fromStream(
                    new ClassPathResource("firebase-service-account.json").getInputStream()
                );

                FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(credentials)
                    .build();

                return FirebaseApp.initializeApp(options);
            } catch (IOException e) {
                // Log the error but don't fail startup
                System.out.println("Firebase configuration not found. Firebase features will be disabled.");
                return null;
            }
        }
        return FirebaseApp.getInstance();
    }
} 