package backend.lezaczek.Helpers;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.annotation.PostConstruct;

@Component
public class JwtTokenHelper {
    @Value("${jwt.secret}")
    private String SECRET;

    @PostConstruct
    public void init(){
        System.out.println(SECRET);
    }
    public String generateToken(String username, long expiration) {
        System.out.println("generateToken: "+SECRET);
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(SignatureAlgorithm.HS256, SECRET)
                .compact();
    }

    public Claims extractClaims(String token) {
        return Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isTokenExpired(String token) {
        return extractClaims(token).getExpiration().before(new Date(System.currentTimeMillis()));
    }

    public String extractUsername(String token) {
        return extractClaims(token).getSubject();
    }
}
