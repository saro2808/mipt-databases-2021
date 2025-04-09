create schema youtube;

create table youtube.user_profile (
    user_id             integer primary key,
    first_nm            varchar(255) not null,
    last_nm             varchar(255) not null,
    gender              varchar(12) not null,
    birth_date          date not null,
    hometown            varchar(255)
);

create table youtube.video (
    video_id        integer primary key,
    user_id         integer not null,
    title           varchar(255) not null,
    description     varchar(1000),
    category        varchar(255),
    like_cnt        integer default 0,
    dislike_cnt     integer default 0,
    view_cnt        integer default 0,
    comment_cnt     integer default 0,
    date_created    date default now()::date,
    duration        integer check (duration >= 3 and duration <= 10000), --in seconds
    constraint  FK_user_video
            foreign key (user_id)
            references youtube.user_profile(user_id)
);

create index video_title_index on youtube.video (title);

create table youtube.comment (
    comment_id      integer primary key,
    user_id         integer not null,
    video_id        integer not null,
    edited          bool default false,
    comment_text    varchar(1000) not null,
    date_created    date default now()::date,
    constraint FK_user_comment
            foreign key (user_id)
            references youtube.user_profile(user_id),
    constraint FK_video_comment
            foreign key (video_id)
            references youtube.video(video_id)
);

create table youtube.playlist (
    playlist_id     integer primary key,
    user_id         integer not null,
    is_private      bool not null,
    view_cnt        integer default 0,
    playlist_name   varchar(250),
    constraint FK_user_playlist
            foreign key (user_id)
            references youtube.user_profile(user_id)
);

create table youtube.video_playlist (
    playlist_id         integer not null,
    video_id            integer not null,
    add_count           integer default 1,
    delete_count        integer default 0,
    date_added          date default now()::date,
    date_deleted        date default null,
    constraint PK_video_playlist
            primary key (video_id, playlist_id, add_count, delete_count),
    constraint FK_playlist_video_playlist
            foreign key (playlist_id)
            references youtube.playlist(playlist_id),
    constraint FK_video_video_playlist
            foreign key (video_id)
            references youtube.video(video_id)
);

create table youtube.saved_playlists (
    user_id     integer not null,
    playlist_id integer not null,
    constraint PK_saved_playlists
            primary key (user_id, playlist_id),
    constraint FK_playlist_saved_playlists
            foreign key (playlist_id)
            references youtube.playlist(playlist_id),
    constraint FK_user_saved_playlists
            foreign key (user_id)
            references youtube.user_profile(user_id)
);

create table youtube.advertisement (
    user_id            integer not null,
    preferred_ad_type  varchar(255),
    constraint PK_advertisement
            primary key (user_id, preferred_ad_type),
    constraint FK_user_advertisement
            foreign key (user_id)
            references youtube.user_profile(user_id)
);

create table youtube.liked_videos (
    user_id     integer not null,
    video_id    integer not null,
    constraint PK_liked_videos
            primary key (user_id, video_id),
    constraint FK_user_liked_videos
            foreign key (user_id)
            references youtube.user_profile(user_id),
    constraint FK_video_liked_videos
            foreign key (video_id)
            references youtube.video(video_id)
);

create table youtube.watch_later (
    user_id     integer not null,
    video_id    integer not null,
    constraint PK_watch_later
            primary key (user_id, video_id),
    constraint FK_user_watch_later
            foreign key (user_id)
            references youtube.user_profile(user_id),
    constraint FK_video_watch_later
            foreign key (video_id)
            references youtube.video(video_id)
);


--insertions into user_profile
insert into youtube.user_profile values (123123, 'Jose', 'Hernandez', 'male', to_date('1990-12-12', 'YYYY-MM-DD'), 'Rosario');
insert into youtube.user_profile values (123234, 'Pham', 'Van Duc', 'male', to_date('1987-08-11', 'YYYY-MM-DD'), 'Hanoi');
insert into youtube.user_profile values (123345, 'Petr', 'Cech', 'male', to_date('1982-05-20', 'YYYY-MM-DD'), 'Pizen');
insert into youtube.user_profile values (123567, 'Christina', 'Aguilera', 'female', to_date('1980-12-18', 'YYYY-MM-DD'), 'New York');
insert into youtube.user_profile values (123456, 'Loic', 'Duval', 'male', to_date('1982-06-12', 'YYYY-MM-DD'), 'Chartres');
insert into youtube.user_profile values (123678, 'Maria', 'Sharapova', 'female', to_date('1987-04-19', 'YYYY-MM-DD'), 'Nyagan');
insert into youtube.user_profile values (123789, 'James', 'Arthur', 'male', to_date('1988-03-02', 'YYYY-MM-DD'), 'Middlesbrough');
insert into youtube.user_profile values (123891, 'Freddie', 'Mercury', 'male', to_date('1946-09-05', 'YYYY-MM-DD'), 'Stone Town');

--insertions into video
insert into youtube.video values (246135, 123123, 'A day in the countryside', null, null, 51, 0, 1553, 2, to_date('2011-08-07', 'YYYY-MM-DD'), 1845);
insert into youtube.video values (246357, 123234, 'Tourist attractions of Hanoi', 'Attend the most spectacular places of  Hanoi', 'tourism, sightseeing', 587, 2, 11036, 56, to_date('2013-11-24', 'YYYY-MM-DD'), 756);
insert into youtube.video values (246579, 123345, 'The best saves of Cech', null, 'sports, football', 23756, 253, 387914, 11407, to_date('2015-03-17', 'YYYY-MM-DD'), 545);
insert into youtube.video values (246791, 123456, 'Interview before 6 hours of Spa', null, 'sports, racing', 45, 2, 789, 5, to_date('2019-04-07', 'YYYY-MM-DD'), 214);
insert into youtube.video values (246911, 123567, 'Christina Aguilera - Genie In A Bottle', 'Christina Aguilera official music video for "Genie In a Bottle"', 'music', 802011, 28455, 171394303, 41628, to_date('2009-10-03', 'YYYY-MM-DD'), 216);
insert into youtube.video values (246111, 123678, 'Interview after the match', null, null, 456, 14, 24681, 627, to_date('2014-05-11', 'YYYY-MM-DD'), 287);
insert into youtube.video values (246113, 123123, '10 DIY advises', 'Do it yourself!', null, 878, 4, 14539, 378, to_date('2017-09-12', 'YYYY-MM-DD'), 578);
insert into youtube.video values (246131, 123789, 'James Arthur - Impossible', 'Music video by James Arthur performing Impossible.', 'music', 2102852, 32567, 218448334, 56625, to_date('2012-12-14', 'YYYY-MM-DD'), 214);
insert into youtube.video values (246151, 123456, 'Loic Duval crash in Le Mans', null, 'sports, racing', 25, 1, 489, 2, to_date('2014-06-11', 'YYYY-MM-DD'), 427);
insert into youtube.video values (246171, 123123, 'How my dog wakes me up', null, null, 25, 0, 714, 6, to_date('2016-01-15', 'YYYY-MM-DD'), 241);
insert into youtube.video values (246818, 123891, 'Freddie Mercury - Living On My Own', 'Remastered in HD!', 'music', 314056, 11145, 49246157, 10284, to_date('2012-11-23', 'YYYY-MM-DD'), 229);

--insertions into comments
insert into youtube.comment values (135111, 123123, 246131, false, 'Wow! What a performance!', to_date('2012-12-15', 'YYYY-MM-DD'));
insert into youtube.comment values (135122, 123456, 246357, false, 'Nice. I am definitely going to attend Hanoi this summer.', to_date('2014-01-14', 'YYYY-MM-DD'));
insert into youtube.comment values (135131, 123789, 246131, true, 'Thanks for your support!', to_date('2012-12-14', 'YYYY-MM-DD'));
insert into youtube.comment values (135411, 123234, 246579, false, 'Unbelievable saves!', to_date('2017-09-06', 'YYYY-MM-DD'));
insert into youtube.comment values (135515, 123567, 246911, true, 'Find my new album here <url>.', to_date('2010-11-09', 'YYYY-MM-DD'));

--insertions into playlist
insert into youtube.playlist values (987112, 123123, false, 51, 'Selected music');
insert into youtube.playlist values (987345, 123234, true, 12, 'Sports interviews');
insert into youtube.playlist values (987598, 123234, true, 8, 'Sports events');

--insertions into video-playlist
insert into youtube.video_playlist values (987112, 246911, 1, 0, to_date('2014-07-07', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987112, 246131, 1, 0, to_date('2014-08-11', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987112, 246818, 1, 0, to_date('2014-10-02', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987345, 246791, 1, 0, to_date('2020-07-06', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987345, 246111, 1, 0, to_date('2020-07-06', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987598, 246151, 1, 0, to_date('2014-06-12', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987598, 246579, 1, 0, to_date('2015-12-30', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987598, 246579, 1, 1, to_date('2015-12-30', 'YYYY-MM-DD'), to_date('2015-12-30', 'YYYY-MM-DD'));
insert into youtube.video_playlist values (987598, 246579, 2, 1, to_date('2015-12-30', 'YYYY-MM-DD'), to_date('9999-01-01', 'YYYY-MM-DD'));

--insertions into saved playlists
insert into youtube.saved_playlists values (123123, 987598);
insert into youtube.saved_playlists values (123123, 987345);
insert into youtube.saved_playlists values (123234, 987112);

--insertions into advertisement
insert into youtube.advertisement values (123123, 'music');
insert into youtube.advertisement values (123234, 'sports');
insert into youtube.advertisement values (123456, 'science');
insert into youtube.advertisement values (123678, 'sports');
insert into youtube.advertisement values (123789, 'music');

--insertions into liked videos
insert into youtube.liked_videos values (123123, 246818);
insert into youtube.liked_videos values (123123, 246131);
insert into youtube.liked_videos values (123123, 246911);
insert into youtube.liked_videos values (123234, 246151);
insert into youtube.liked_videos values (123123, 246113);

--insertions into watch later
insert into youtube.watch_later values (123123, 246579);
insert into youtube.watch_later values (123123, 246911);
insert into youtube.watch_later values (123789, 246135);
insert into youtube.watch_later values (123456, 246791);
insert into youtube.watch_later values (123567, 246911);


--how many users prefer this or that type of ads
select count(user_id), preferred_ad_type
from youtube.advertisement
group by preferred_ad_type;


--which users have a playlist with a video with >=30000 views
with playlist_gt_1000 (playlist_id)
as (
    select distinct playlist_id
    from youtube.video_playlist
    inner join youtube.video
    on video_playlist.video_id = video.video_id
    where video.view_cnt >= 30000
    )
select distinct user_profile.user_id, first_nm, last_nm
from youtube.user_profile
inner join (
    youtube.playlist
    inner join playlist_gt_1000
    on playlist.playlist_id = playlist_gt_1000.playlist_id
    )
on user_profile.user_id = playlist.user_id;


--which users have been active between 2013 and 2015 inclusive
--that is which users have
--uploaded a video OR
--commented on a video OR
--modified a playlist (
--added a video into a playlist OR
--deleted a video from a playlist
--)
select user_id, first_nm, last_nm
from
(
--users that uploaded videos
    select distinct user_profile.user_id, first_nm, last_nm
    from (
             select *
             from youtube.video
             where date_created < to_date('2016-01-01', 'YYYY-MM-DD')
               and to_date('2013-01-01', 'YYYY-MM-DD') <= date_created
         ) as vd
             inner join youtube.user_profile
                        on vd.user_id = user_profile.user_id
) user_upload
union
(
--users that commented on a video
    select distinct user_profile.user_id, first_nm, last_nm
    from (
             select *
             from youtube.comment
             where date_created < to_date('2016-01-01', 'YYYY-MM-DD')
               and to_date('2013-01-01', 'YYYY-MM-DD') <= date_created
         ) as cm
             inner join youtube.user_profile
                        on cm.user_id = user_profile.user_id
)
union
(
--users that modified a playlist
    select distinct user_profile.user_id, first_nm, last_nm
    from (
         (
             select distinct playlist_id
             from youtube.video_playlist
             where (date_added < to_date('2016-01-01', 'YYYY-MM-DD')
                 and to_date('2013-01-01', 'YYYY-MM-DD') <= date_added)
                or (date_deleted < to_date('2016-01-01', 'YYYY-MM-DD')
                 and to_date('2013-01-01', 'YYYY-MM-DD') <= date_deleted)
         ) pid
             inner join youtube.playlist
             on pid.playlist_id = playlist.playlist_id
         ) upid
    inner join youtube.user_profile
    on upid.user_id = user_profile.user_id
);


create or replace function youtube.update_video_playlist()
returns trigger as $$
    begin
        if new.add_count = new.delete_count then
            delete from youtube.video_playlist
            where video_id = new.video_id
            and playlist_id = new.playlist_id
            and add_count = new.add_count;
        elsif new.add_count = new.delete_count + 1 then
            if new.date_deleted != to_date('9999-01-01', 'YYYY-MM-DD') then
                raise exception 'error: date deleted should be set to 9999-01-01';
            end if;
        else
            raise exception 'error: add_count - delete_count should be either 0 or 1';
        end if;
        return new;
    end;
$$ language plpgsql;


create trigger handle_video_playlist_changes
before insert on youtube.video_playlist
for each row
execute procedure youtube.update_video_playlist();


create or replace function youtube.views_per_user()
 returns table (user_id integer, count bigint) as $$
    begin
        return query (
            select youtube.video.user_id, sum(youtube.video.view_cnt)
            from youtube.video
            group by youtube.video.user_id
            );
    end
$$ language plpgsql;


create user me_the_owner with password 'MeTheOwner';
grant all privileges on schema youtube to me_the_owner with grant option;

create user info_adder with password 'InfoAdder';
grant insert on all tables in schema youtube to info_adder with grant option;
grant create on schema youtube to info_adder with grant option;

create user just_a_user with password 'JustAUser';
grant usage on schema youtube to just_a_user;

create role selector;
grant select on all tables in schema youtube to selector;

create role moderator;
grant insert, delete, update on all tables in schema youtube to moderator;
