package backend.lezaczek.Services;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import backend.lezaczek.Interfaces.SessionRepository;
import backend.lezaczek.Model.Session;

@Service
public class SessionService {
    @Autowired
    private SessionRepository sessionRepository;
    @Query(value = "SELECT * FROM Sessions WHERE sessionToken = ?", nativeQuery = true)
    public Session getSession(@RequestParam String sessionToken) {
        return sessionRepository.findByToken(sessionToken);
    }
    public Session saveSession(Session session) {
        return sessionRepository.save(session);
    }
}
