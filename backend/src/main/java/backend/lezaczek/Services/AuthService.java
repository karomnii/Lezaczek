package backend.lezaczek.Services;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import java.util.Arrays;
import java.util.Random;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.AuthResponse;
import backend.lezaczek.Model.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class AuthService {
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    private static final Random RANDOM = new SecureRandom();
    private static final int ITERATIONS = 10000;
    private static final int KEY_LENGTH = 256;
    private static final long ACCESS_TOKEN_EXPIRATION = 1000 * 60 * 15; // 15 minutes
    private static final long REFRESH_TOKEN_EXPIRATION = 1000 * 60 * 60 * 24 * 7; // 7 days

    public static byte[] hash(char[] password, byte[] salt) {
        PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, KEY_LENGTH);
        Arrays.fill(password, Character.MIN_VALUE);
        try {
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
            return skf.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new AssertionError("Error while hashing a password: " + e.getMessage(), e);
        } finally {
            spec.clearPassword();
        }
    }

    public static byte[] getSalt() {
        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);
        return salt;
    }

    private boolean comparePasswords(char[] password, byte[] salt, byte[] expectedHash) {
        byte[] pwdHash = hash(password, salt);
        Arrays.fill(password, Character.MIN_VALUE);
        if (pwdHash.length != expectedHash.length)
            return false;
        for (int i = 0; i < pwdHash.length; i++) {
            if (pwdHash[i] != expectedHash[i])
                return false;
        }
        return true;
    }

    public Boolean authenticate(User dbUser, String password) {
        byte[] salt = dbUser.getSalt().getBytes(StandardCharsets.ISO_8859_1);
        byte[] hashedPassword = dbUser.getPassword().getBytes(StandardCharsets.ISO_8859_1);
        return comparePasswords(password.toCharArray(), salt, hashedPassword);
    }

    public AuthResponse setCookies(User user, HttpServletResponse response) {
        String accessToken = jwtTokenHelper.generateToken(user.getUserId(), ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtTokenHelper.generateToken(user.getUserId(), REFRESH_TOKEN_EXPIRATION);
        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        accessTokenCookie.setHttpOnly(true);
        accessTokenCookie.setSecure(true);
        accessTokenCookie.setPath("/");
        accessTokenCookie.setMaxAge((int) ACCESS_TOKEN_EXPIRATION / 1000);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setSecure(true);
        refreshTokenCookie.setPath("/api/v1/auth/refresh");
        refreshTokenCookie.setMaxAge((int) REFRESH_TOKEN_EXPIRATION / 1000);
        response.addCookie(accessTokenCookie);
        response.addCookie(refreshTokenCookie);
        return new AuthResponse(accessToken, refreshToken, user);
    }

    public String refreshCookies(User user, HttpServletResponse response) {
        String accessToken = jwtTokenHelper.generateToken(user.getUserId(), ACCESS_TOKEN_EXPIRATION);
        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        accessTokenCookie.setHttpOnly(true);
        accessTokenCookie.setSecure(true);
        accessTokenCookie.setPath("/");
        response.addCookie(accessTokenCookie);
        return accessToken;
    }
}