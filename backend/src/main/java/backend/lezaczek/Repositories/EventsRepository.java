package backend.lezaczek.Repositories;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import backend.lezaczek.Model.Event;

@Repository
public interface EventsRepository extends JpaRepository<Event, Long>{
    
}
