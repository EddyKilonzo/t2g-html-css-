--

-- CREATE DATABASE hotel_db;




-- Table: guests
-- CREATE TABLE guests (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     phone VARCHAR(100) NOT NULL,
--     email VARCHAR(50) UNIQUE NOT NULL,
--     check_in_date DATE,
--     check_out_date DATE
-- );

-- Table: rooms
-- CREATE TABLE rooms (
--     id SERIAL PRIMARY KEY,
--     number VARCHAR(100) UNIQUE NOT NULL,
--     type VARCHAR(100) NOT NULL,
--     price_per_night DECIMAL(10,2) NOT NULL,
--     is_available BOOLEAN
-- );

-- Table: bookings
-- CREATE TABLE bookings (
--     id SERIAL PRIMARY KEY,
--     guests_id INT NOT NULL, -- User's column name
--     room_id INT NOT NULL,
--     booking_date DATE NOT NULL,
--     nights INT NOT NULL,
--     total_price DECIMAL(10,2) NOT NULL,
--     FOREIGN KEY(guests_id) REFERENCES guests(id) ON DELETE CASCADE, -- Added ON DELETE CASCADE for consistency
--     FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE
-- );

-- Table: services
-- CREATE TABLE services (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     price DECIMAL(10,2) NOT NULL
-- );

-- Table: guest_services
-- CREATE TABLE guest_services (
--     id SERIAL PRIMARY KEY,
--     guest_id INT NOT NULL,
--     services_id INT NOT NULL, -- User's column name
--     date_used DATE NOT NULL,
--     FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE,
--     FOREIGN KEY (services_id) REFERENCES services(id) ON DELETE CASCADE
-- );

-- -----------------------------------------------------
-- Task 1: SQL Data Types & Basic SELECT
-- -----------------------------------------------------

-- Insert at least 5 guests 
-- INSERT INTO guests (name, email, phone, check_in_date, check_out_date) VALUES
--     ('Eddy', 'eddy@gmail.com', '07681683367', '2025-05-25', '2025-05-27'),
--     ('Max', 'max@gmail.com', '0703526510', '2025-05-23', '2025-05-25'),
--     ('Edda', 'edda@gmail.com', '0701984805', '2025-05-18', '2025-05-21'),
--     ('Cythnia', 'cynthia@gmail.com','0741283206', '2025-05-16', '2025-05-23'),
--     ('John', 'john@gmail.com', '0111666710', '2025-04-10', '2025-04-25');

-- SELECT * FROM guests;

-- Insert at least 3 rooms 
-- INSERT INTO rooms (number, type, price_per_night, is_available) VALUES
--     ('109a', 'single', 1500.00, TRUE),
--     ('123b', 'double', 2500.00, TRUE),
--     ('184a', 'suite', 5000, FALSE);

-- SELECT * FROM rooms;

-- -- Insert at least 3 services
-- INSERT INTO services (name, price) VALUES
--     ('Breakfast', 1000),
--     ('spa', 3000),
--     ('massage', 2000);

SELECT * FROM services;

-- Insert some initial guest services 
-- INSERT INTO guest_services (guest_id, services_id, date_used) VALUES
--     (2, 1, '2025-05-24'),
--     (1, 2, '2025-05-26'),
--     (3, 3, '2025-05-20'),
--     (2, 3, '2025-05-24'), 
--     (3, 1, '2025-05-21'), 
--     (1, 1, '2025-05-27'), 
--     (1, 2, '2025-05-27'); 

SELECT * FROM guest_services;

-- Select guest names and phone numbers
SELECT name, phone FROM guests;

-- Task 2: Modifying Data


-- Insert a new guest (corrected date format)
-- INSERT INTO guests (name, email, phone, check_in_date, check_out_date) VALUES
--     ('Tony', 'tony@gmail.com', '0748255789', '2025-04-12', '2025-04-13');
-- SELECT * FROM guests;

-- 
-- INSERT INTO bookings (guests_id, room_id, booking_date, nights, total_price) VALUES
--     ((SELECT id FROM guests WHERE email = 'tony@gmail.com'), (SELECT id FROM rooms WHERE number = '109a'), '2025-04-11', 1, 1500.00);


-- INSERT INTO bookings (guests_id, room_id, booking_date, nights, total_price) VALUES
--     ((SELECT id FROM guests WHERE email = 'max@gmail.com'), (SELECT id FROM rooms WHERE number = '123b'), '2025-05-22', 2, 5000),
--     ((SELECT id FROM guests WHERE email = 'edda@gmail.com'), (SELECT id FROM rooms WHERE number = '184a'), '2025-05-17', 1, 5000),
--     ((SELECT id FROM guests WHERE email = 'cynthia@gmail.com'), (SELECT id FROM rooms WHERE number = '184a'), '2025-05-15', 1, 5000),
--     ((SELECT id FROM guests WHERE email = 'max@gmail.com'), (SELECT id FROM rooms WHERE number = '184a'), '2025-05-14', 1, 5000),
--     ((SELECT id FROM guests WHERE email = 'eddy@gmail.com'), (SELECT id FROM rooms WHERE number = '184a'), '2025-05-12', 1, 5000); 

SELECT * FROM bookings;

-- Update a guest’s check-out
-- UPDATE guests SET check_out_date = '2025-05-28' WHERE id = 1;

SELECT * FROM guests;

-- Delete a guest who checked out more than 1 month ago 
-- DELETE FROM guests WHERE check_out_date < CURRENT_DATE - INTERVAL '1 month';
-- SELECT * FROM guests;

-- -----------------------------------------------------
-- Task 3: Filtering & Grouping


SELECT g.name, g.email, g.phone, b.booking_date
FROM guests g
JOIN bookings b ON g.id = b.guests_id
WHERE b.booking_date > '2025-05-23';

-- Group bookings by room_id and show average nights stayed
SELECT room_id, AVG(nights) AS average_nights
FROM bookings
GROUP BY room_id;

-- -----------------------------------------------------
-- Task 4: Joins & Subqueries


-- List guests and the rooms they’re staying in (JOIN)
SELECT g.name AS guest_name, r.number AS room_number, r.type AS room_type
FROM guests g
LEFT JOIN bookings b ON g.id = b.guests_id
LEFT JOIN rooms r ON b.room_id = r.id;

-- Subquery to find guests who have used more than 2 services
SELECT g.name
FROM guests g
WHERE g.id IN (
    SELECT gs.guest_id
    FROM guest_services gs
    GROUP BY gs.guest_id
    HAVING COUNT(*) > 2
);

-- -----------------------------------------------------
-- Task 5: Views & Pagination


-- Create a view showing guest name, room number, total price 
CREATE OR REPLACE VIEW guest_room_view AS
SELECT g.name AS guest_name, r.number AS room_number, b.total_price, b.booking_date
FROM guests g
JOIN bookings b ON g.id = b.guests_id
JOIN rooms r ON b.room_id = r.id;

-- Paginate the view to show 3 bookings at a time 
-- First 3 bookings
SELECT * FROM guest_room_view LIMIT 3 OFFSET 0;
-- Next 3 bookings
SELECT * FROM guest_room_view LIMIT 3 OFFSET 3;

-- -----------------------------------------------------
-- Task 6: Sorting & Limiting

-- Sort guests by check-in date (descending)
SELECT * FROM guests ORDER BY check_in_date DESC;
-- Limit results to the 5 most recent guests
SELECT * FROM guests ORDER BY check_in_date DESC LIMIT 5;

-- -----------------------------------------------------
-- Task 7: Constraints & Expressions, SET Operators, CTEs




-- Use CASE to categorize rooms (Economy, Business, Luxury) based on price_per_night
SELECT
    number,
    type,
    price_per_night,
    CASE
        WHEN price_per_night < 1600 THEN 'Economy'
        WHEN price_per_night BETWEEN 1600 AND 2600 THEN 'Business'
        ELSE 'Luxury'
    END AS category
FROM rooms;

-- Use a CTE to find rooms booked more than 3 times
WITH room_booking_counts AS (
    SELECT
        room_id,
        COUNT(*) as booking_count
    FROM bookings
    GROUP BY room_id
)
SELECT
    r.number,
    r.type,
    rbc.booking_count
FROM room_booking_counts rbc
JOIN rooms r ON rbc.room_id = r.id
WHERE rbc.booking_count > 3;

-- Use UNION to combine guests who booked a room or used a spa service
SELECT DISTINCT g.id, g.name, 'Booked Room' AS activity
FROM guests g
JOIN bookings b ON g.id = b.guests_id
UNION
SELECT DISTINCT g.id, g.name, 'Used Spa Service' AS activity
FROM guests g
JOIN guest_services gs ON g.id = gs.guest_id
JOIN services s ON gs.services_id = s.id
WHERE s.name = 'spa' 
ORDER BY name, activity;

-- -----------------------------------------------------
-- Task 8: Triggers & Indexes



-- Create a table to log room availability updates
CREATE TABLE room_availability_log (
    log_id SERIAL PRIMARY KEY,
    room_id INT,
    old_is_available BOOLEAN,
    new_is_available BOOLEAN,
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(255) DEFAULT CURRENT_USER
);

-- Create a function for the trigger
CREATE OR REPLACE FUNCTION trg_rooms_availability_update_func()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.is_available IS DISTINCT FROM NEW.is_available THEN
        INSERT INTO room_availability_log (room_id, old_is_available, new_is_available)
        VALUES (OLD.id, OLD.is_available, NEW.is_available);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to log updates to rooms availability
CREATE TRIGGER trg_rooms_availability_update
AFTER UPDATE ON rooms
FOR EACH ROW
EXECUTE FUNCTION trg_rooms_availability_update_func();

-- Test 
UPDATE rooms SET is_available = FALSE WHERE number = '109a';
UPDATE rooms SET is_available = TRUE WHERE number = '123b';

SELECT * FROM room_availability_log;

--  index on bookings.booking_date for faster lookups
CREATE INDEX idx_bookings_booking_date ON bookings(booking_date);

-- -----------------------------------------------------
-- Task 9: User Defined Functions & Stored Procedures


-- function to calculate total spend for a guest
CREATE OR REPLACE FUNCTION CalculateGuestTotalSpend(p_guest_id INT)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    total_booking_spend DECIMAL(10, 2);
    total_service_spend DECIMAL(10, 2);
BEGIN
    -- Calculate total spend from bookings 
    SELECT COALESCE(SUM(total_price), 0)
    INTO total_booking_spend
    FROM bookings
    WHERE guests_id = p_guest_id;

    -- Calculate total spend from services 
    SELECT COALESCE(SUM(s.price), 0)
    INTO total_service_spend
    FROM guest_services gs
    JOIN services s ON gs.services_id = s.id
    WHERE gs.guest_id = p_guest_id;

    RETURN total_booking_spend + total_service_spend;
END;
$$;

-- Test the function
SELECT
    g.name,
    CalculateGuestTotalSpend(g.id) AS total_spend
FROM guests g
WHERE g.name = 'Eddy';

SELECT
    g.name,
    CalculateGuestTotalSpend(g.id) AS total_spend
FROM guests g
WHERE g.name = 'Max';


-- a stored procedure to add a booking
CREATE OR REPLACE PROCEDURE AddBooking(
    IN p_guests_id INT,
    IN p_room_id INT,
    IN p_booking_date DATE,
    IN p_nights INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price_per_night DECIMAL(10, 2);
    v_total_price DECIMAL(10, 2);
    v_is_available BOOLEAN;
BEGIN
    -- Get room details
    SELECT price_per_night, is_available
    INTO v_price_per_night, v_is_available
    FROM rooms
    WHERE id = p_room_id;

    -- Check if room is available
    IF v_is_available IS NULL OR v_is_available = TRUE THEN -- Consider NULL as available or handle explicitly
        v_total_price = v_price_per_night * p_nights;

        INSERT INTO bookings (guests_id, room_id, booking_date, nights, total_price)
        VALUES (p_guests_id, p_room_id, p_booking_date, p_nights, v_total_price);

        RAISE NOTICE 'Booking added successfully for guest ID % in room ID %.', p_guests_id, p_room_id;
    ELSE
        RAISE NOTICE 'Room is not available for booking.';
    END IF;
END;
$$;


-- Try to book an unavailable room 
CALL AddBooking((SELECT id FROM guests WHERE email = 'eddy@gmail.com'), (SELECT id FROM rooms WHERE number = '184a'), '2025-06-01', 2);
-- Book an available room (123b) for a guest
CALL AddBooking((SELECT id FROM guests WHERE email = 'cynthia@gmail.com'), (SELECT id FROM rooms WHERE number = '123b'), '2025-06-10', 3);
SELECT * FROM bookings ORDER BY id DESC LIMIT 2; 


-- a procedure to check in a new guest and book them into a room.
CREATE OR REPLACE PROCEDURE CheckInNewGuestAndBook(
    IN p_guest_name VARCHAR(100),
    IN p_guest_email VARCHAR(50),
    IN p_guest_phone VARCHAR(100),
    IN p_check_in_date DATE,
    IN p_check_out_date DATE,
    IN p_room_number VARCHAR(100),
    IN p_booking_date DATE,
    IN p_nights INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_guest_id INT;
    v_room_id INT;
    v_price_per_night DECIMAL(10, 2);
    v_total_price DECIMAL(10, 2);
    v_is_available BOOLEAN;
BEGIN
    

    -- 1. Insert new guest and get ID
    INSERT INTO guests (name, email, phone, check_in_date, check_out_date)
    VALUES (p_guest_name, p_guest_email, p_guest_phone, p_check_in_date, p_check_out_date)
    RETURNING id INTO v_guest_id;

    -- 2. Get room details
    SELECT id, price_per_night, is_available
    INTO v_room_id, v_price_per_night, v_is_available
    FROM rooms
    WHERE number = p_room_number;

    -- Check if room exists and is available
    IF v_room_id IS NULL THEN
        RAISE EXCEPTION 'Error: Room with number % not found.', p_room_number;
    ELSIF v_is_available = FALSE THEN
        RAISE EXCEPTION 'Error: Room % is not available.', p_room_number;
    ELSE
        -- 3. Calculate total price and add booking
        v_total_price = v_price_per_night * p_nights;

        INSERT INTO bookings (guests_id, room_id, booking_date, nights, total_price)
        VALUES (v_guest_id, v_room_id, p_booking_date, p_nights, v_total_price);

        -- 4. Update room availability (set to FALSE as it's now occupied)
        UPDATE rooms
        SET is_available = FALSE
        WHERE id = v_room_id;

        RAISE NOTICE 'Guest "%" checked in and room "%" booked successfully! Guest ID: %, Room ID: %', p_guest_name, p_room_number, v_guest_id, v_room_id;
    END IF;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Error: A guest with email "%" already exists.', p_guest_email;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'An unexpected error occurred: %', SQLERRM;
END;
$$;

-- Test 
CALL CheckInNewGuestAndBook(
    'New Guest One',
    'new.guest1@example.com',
    '0712345678',
    '2025-06-15',
    '2025-06-18',
    '109a', 
    '2025-06-14',
    3
);

--
SELECT * FROM guests WHERE email = 'new.guest1@example.com';
SELECT * FROM bookings WHERE guests_id = (SELECT id FROM guests WHERE email = 'new.guest1@example.com');
SELECT * FROM rooms WHERE number = '109a'; 

-- 
CALL CheckInNewGuestAndBook(
    'New Guest Two',
    'new.guest2@example.com',
    '0798765432',
    '2025-06-20',
    '2025-06-22',
    '109a', 
    '2025-06-19',
    2
);

-- Try to add a guest with a duplicate email
CALL CheckInNewGuestAndBook(
    'Eddy Duplicate',
    'eddy@gmail.com', 
    '0711111111',
    '2025-07-01',
    '2025-07-03',
    '123b',
    '2025-06-30',
    2
);
