<?php
require __DIR__.'/Module/Database.php';

class Table extends  Database
{
    /**
     * Table constructor.
     */
    public function __construct()
    {
        parent::__construct();

        $this->install();
    }

    public function install(){

        // ===========================
        // KooBus Core Tables
        // ===========================
        // NOTE: Schema inajengwa hatua kwa hatua kulingana na Phase 5
        // Tables hapa ni za msingi tu - tutaziongeza zaidi tukifika ERD kamili

        // users table (core auth/users)
        parent::createTable($this->encode(array(
            'name'=>'users',
            'value'=>"
             id int(11) not null auto_increment,
             first_name varchar(50) null,
             last_name varchar(50) null,
             username varchar(100) null,
             email varchar(100) null,
             phone varchar(20) not null,
             gender enum('male', 'female', 'notspecified') default 'notspecified',
             avatar text null,
             bio text null,
             password text not null,
             role enum('parent','driver','matron','school_admin','super_admin') default 'parent' not null,
             school_id int(11) null,
             status enum('0','1') not null default '0',
             device_token text null,
             last_login datetime null,
             created_at datetime not null default current_timestamp,
             updated_at datetime null on update current_timestamp,
             token text null,
             primary key(id),
             unique key unique_phone (phone),
             unique key unique_email (email)
             "
        )));

        // schools
        parent::createTable($this->encode(array(
            'name'=>'schools',
            'value'=>"
            id int(11) not null auto_increment,
            name varchar(150) not null,
            address text null,
            phone varchar(20) null,
            email varchar(100) null,
            status enum('0','1') default '1',
            created_at datetime not null default current_timestamp,
            primary key(id)
            "
        )));

        // KOO_BUS_ADAPT: school_id kwa users (school-level isolation).
        // users inaundwa kabla ya schools, hivyo column/FK inaongezwa hapa
        // baada ya schools kuwepo. Hii pia inashughulikia DB ya zamani.
        $this->ensureUsersSchoolColumn();

        // buses
        parent::createTable($this->encode(array(
            'name'=>'buses',
            'value'=>"
            id int(11) not null auto_increment,
            plate_number varchar(20) not null,
            capacity int(11) default 0,
            school_id int(11) null,
            status enum('0','1') default '1',
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(school_id) references schools(id) on delete set null,
            unique key unique_plate (plate_number)
            "
        )));

        // routes
        parent::createTable($this->encode(array(
            'name'=>'routes',
            'value'=>"
            id int(11) not null auto_increment,
            school_id int(11) not null,
            name varchar(100) not null,
            description text null,
            status enum('0','1') default '1',
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(school_id) references schools(id) on delete cascade
            "
        )));

        // route_stops
        parent::createTable($this->encode(array(
            'name'=>'route_stops',
            'value'=>"
            id int(11) not null auto_increment,
            route_id int(11) not null,
            name varchar(100) not null,
            latitude decimal(10,7) null,
            longitude decimal(10,7) null,
            stop_order int(11) not null,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(route_id) references routes(id) on delete cascade
            "
        )));

        // children
        parent::createTable($this->encode(array(
            'name'=>'children',
            'value'=>"
            id int(11) not null auto_increment,
            school_id int(11) not null,
            first_name varchar(50) not null,
            last_name varchar(50) not null,
            class_name varchar(50) null,
            route_id int(11) null,
            status enum('active','inactive') default 'active',
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(school_id) references schools(id) on delete cascade,
            foreign key(route_id) references routes(id) on delete set null
            "
        )));

        // parent_children (guardian links)
        parent::createTable($this->encode(array(
            'name'=>'parent_children',
            'value'=>"
            id int(11) not null auto_increment,
            parent_id int(11) not null,
            child_id int(11) not null,
            relation varchar(50) null,
            is_primary tinyint(1) default 0,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(parent_id) references users(id) on delete cascade,
            foreign key(child_id) references children(id) on delete cascade,
            unique key unique_parent_child (parent_id, child_id)
            "
        )));

        // trips
        parent::createTable($this->encode(array(
            'name'=>'trips',
            'value'=>"
            id int(11) not null auto_increment,
            route_id int(11) not null,
            bus_id int(11) not null,
            driver_id int(11) not null,
            matron_id int(11) null,
            trip_type enum('morning','afternoon') not null,
            status enum('pending','active','completed','cancelled') default 'pending',
            started_at datetime null,
            ended_at datetime null,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(route_id) references routes(id) on delete cascade,
            foreign key(bus_id) references buses(id) on delete cascade,
            foreign key(driver_id) references users(id) on delete cascade,
            foreign key(matron_id) references users(id) on delete set null
            "
        )));

        // trip_events (boarding/alighting/absent etc)
        parent::createTable($this->encode(array(
            'name'=>'trip_events',
            'value'=>"
            id int(11) not null auto_increment,
            trip_id int(11) not null,
            child_id int(11) not null,
            stop_id int(11) null,
            event_type enum('board','alight','absent','excused') not null,
            recorded_by int(11) null,
            latitude decimal(10,7) null,
            longitude decimal(10,7) null,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(trip_id) references trips(id) on delete cascade,
            foreign key(child_id) references children(id) on delete cascade,
            foreign key(stop_id) references route_stops(id) on delete set null,
            foreign key(recorded_by) references users(id) on delete set null
            "
        )));

        // locations (live GPS tracking)
        parent::createTable($this->encode(array(
            'name'=>'locations',
            'value'=>"
            id int(11) not null auto_increment,
            trip_id int(11) not null,
            driver_id int(11) not null,
            latitude decimal(10,7) not null,
            longitude decimal(10,7) not null,
            speed decimal(6,2) null,
            accuracy decimal(6,2) null,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(trip_id) references trips(id) on delete cascade,
            foreign key(driver_id) references users(id) on delete cascade
            "
        )));

        // notifications
        parent::createTable($this->encode(array(
            'name'=>'notifications',
            'value'=>"
            id int(11) not null auto_increment,
            user_id int(11) not null,
            title varchar(150) not null,
            body text not null,
            type varchar(50) null,
            data json null,
            read_at datetime null,
            created_at datetime not null default current_timestamp,
            primary key(id),
            foreign key(user_id) references users(id) on delete cascade
            "
        )));

        // device_tokens (FCM)
        parent::createTable($this->encode(array(
            'name'=>'device_tokens',
            'value'=>"
            id int(11) not null auto_increment,
            user_id int(11) not null,
            token text not null,
            platform enum('android','ios') default 'android',
            created_at datetime not null default current_timestamp,
            updated_at datetime null on update current_timestamp,
            primary key(id),
            foreign key(user_id) references users(id) on delete cascade
            "
        )));

        // TODO (Post-MVP): trip_attendance, fee_invoices, fee_payments, transport_providers, school_announcements, complaints
        // See FUTURE_UX_IDEAS.md

        echo "\n KooBus tables installed/checked successfully!\n";
    }

    /**
     * KOO_BUS_ADAPT: hakikisha users.school_id ipo na FK yake.
     *
     * `createTable` haibadilishi table iliyopo, hivyo kwa DB ya zamani
     * tunaongeza column hii kwa ALTER (mara moja tu).
     */
    private function ensureUsersSchoolColumn(){
        $db = $this->con->query("SELECT DATABASE() AS db")->fetch_object();
        $schema = $db ? $db->db : '';

        $col = $this->con->query("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA='".$this->con->real_escape_string($schema)."'
            AND TABLE_NAME='users' AND COLUMN_NAME='school_id'");
        if($col && $col->num_rows === 0){
            $this->con->query("ALTER TABLE users ADD COLUMN school_id int(11) null");
        }

        $fk = $this->con->query("SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
            WHERE TABLE_SCHEMA='".$this->con->real_escape_string($schema)."'
            AND TABLE_NAME='users' AND CONSTRAINT_TYPE='FOREIGN KEY'
            AND CONSTRAINT_NAME='fk_users_school'");
        if($fk && $fk->num_rows === 0){
            $this->con->query("ALTER TABLE users ADD CONSTRAINT fk_users_school
                FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE SET NULL");
        }
    }

}

new Table();
