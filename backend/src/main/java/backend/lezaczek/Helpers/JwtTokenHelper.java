package backend.lezaczek.Helpers;

import java.sql.Date;

import org.springframework.beans.factory.annotation.Value;
import jakarta.servlet.http.Cookie;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;

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
    public Claims extractClaims(HttpServletRequest request) throws Throwable {
        String token;
        for (Cookie cookie : request.getCookies()){
            if (cookie.getName().equals("refreshToken")){
                token = cookie.getValue();
                return extractClaims(token);
            }
        }
        throw new Throwable("no cookie");
    }
    public Claims extractClaims(String token) {
        return Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isTokenExpired(String token) {
        try {
            extractClaims(token).getExpiration().before(new Date(System.currentTimeMillis()));
        } catch (ExpiredJwtException e){
            return true;
        }
        return false;
    }

    public String extractUserId(String token) {
        return extractClaims(token).getSubject();
    }
    public String extractUserId(HttpServletRequest request) throws Throwable{
        String token;
        for (Cookie cookie : request.getCookies()){
            if (cookie.getName().equals("accessToken")){
                token = cookie.getValue();
                return extractUserId(token);
            }
        }
        throw new Throwable("no cookie");
    }
}
