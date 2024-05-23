package backend.lezaczek.Interfaces;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import backend.lezaczek.Model.Session;

@Repository
public interface SessionRepository extends JpaRepository<Session, Long>{
    Session findByToken(String token);
}