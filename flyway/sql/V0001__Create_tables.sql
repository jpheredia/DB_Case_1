CREATE TYPE gender_t as ENUM ('M','F');
CREATE TYPE employee_status_t as enum ('Active', 'Inactive');

CREATE TABLE departments(
    dept_num UUID PRIMARY KEY default gen_random_uuid(),
    dept_name text not null
);

CREATE TABLE employees(
    SSN varchar(8) PRIMARY KEY check (SSN ~ '^[0-9]{8}$'),
    first_name text not null,
    last_name text not null,
    gender gender_t NOT NULL,
    birthday_date date not null,
    dept_num UUID not null,
    supervisor_ssn varchar(8),
    employee_status employee_status_t not null default 'Active',

    FOREIGN KEY (dept_num) REFERENCES departments(dept_num) on update cascade on delete RESTRICT,
    FOREIGN KEY (supervisor_ssn) REFERENCES employees (SSN) on update cascade on delete SET NULL,

    CONSTRAINT chk_employee_not_own_supervisor
        CHECK (supervisor_ssn IS NULL OR supervisor_ssn <> ssn)
);

CREATE TABLE projects(
    project_num UUID PRIMARY KEY default gen_random_uuid(),
    project_name text,
    city text not null,
    dept_num UUID,

    FOREIGN KEY (dept_num) REFERENCES departments (dept_num) on update cascade on delete set NULL
);

CREATE TABLE departments_locations (
    dept_num UUID not null,
    dept_location text not null,

    PRIMARY KEY(dept_num,dept_location),

    FOREIGN KEY (dept_num) REFERENCES departments (dept_num) on update cascade on delete cascade
);

CREATE TABLE managers(
    employee_ssn varchar(8) not null,
    dept_num UUID not null unique,
    hiring_date date not null,

    PRIMARY KEY (dept_num,employee_ssn),

    FOREIGN KEY (employee_ssn) REFERENCES employees (SSN) on update cascade on delete cascade,
    FOREIGN KEY (dept_num) REFERENCES departments (dept_num) on update cascade on delete RESTRICT
);

CREATE TABLE employee_projects(
    employee_ssn varchar(8) not null,
    project_num UUID not null,
    n_working_hours numeric(6,2) NOT NULL DEFAULT 0.00 CHECK (n_working_hours >= 0),

    PRIMARY KEY (employee_ssn,project_num),

    FOREIGN KEY (employee_ssn) REFERENCES employees (SSN) on update cascade,
    FOREIGN KEY (project_num) REFERENCES projects (project_num) on update cascade on delete cascade
);

CREATE TABLE dependent(
    dependent_id UUID not null default gen_random_uuid(),
    first_name text not null,
    last_name text not null,
    gender gender_t not null,
    employee_ssn varchar(8) not null,

    PRIMARY KEY (employee_ssn, dependent_id),

    FOREIGN KEY (employee_ssn) REFERENCES employees (SSN) on update cascade on delete cascade
);