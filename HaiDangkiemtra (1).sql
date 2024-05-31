CREATE DATABASE QuanLyDiem;
GO

-- Sử dụng cơ sở dữ liệu
USE QuanLyDiem;
GO

-- Tạo bảng Lớp học
CREATE TABLE LopHoc (
    MaLop INT PRIMARY KEY,
    TenLop NVARCHAR(50)
);
GO

-- Tạo bảng Môn học
CREATE TABLE MonHoc (
    MaMon INT PRIMARY KEY,
    TenMon NVARCHAR(50)
);
GO

-- Tạo bảng Học sinh
CREATE TABLE HocSinh (
    MaHS INT PRIMARY KEY,
    TenHS NVARCHAR(50),
    MaLop INT FOREIGN KEY REFERENCES LopHoc(MaLop)
);
GO

-- Tạo bảng Điểm số
CREATE TABLE Diem (
    MaHS INT FOREIGN KEY REFERENCES HocSinh(MaHS),
    MaMon INT FOREIGN KEY REFERENCES MonHoc(MaMon),
    Diem FLOAT,
    PRIMARY KEY (MaHS, MaMon)
);
GO

-- Thêm dữ liệu mẫu vào bảng LopHoc
INSERT INTO LopHoc (MaLop, TenLop)
VALUES (1, N'Lớp 1A'),
       (2, N'Lớp 1B'),
       (3, N'Lớp 2A'),
       (4, N'Lớp 2B'),
       (5, N'Lớp 3A'),
       (6, N'Lớp 3B');
       
-- Thêm dữ liệu mẫu vào bảng MonHoc
INSERT INTO MonHoc (MaMon, TenMon)
VALUES (1, N'Toán'),
       (2, N'Văn'),
       (3, N'Anh'),
       (4, N'Lý'),
       (5, N'Hóa'),
       (6, N'Sinh');
       
-- Thêm dữ liệu mẫu vào bảng HocSinh
INSERT INTO HocSinh (MaHS, TenHS, MaLop)
VALUES (1, N'Nguyễn Văn A', 1),
       (2, N'Nguyễn Thị B', 2),
       (3, N'Trần Văn C', 1),
       (4, N'Lê Thị D', 3),
       (5, N'Phạm Văn E', 4),
       (6, N'Huỳnh Thị F', 5),
       (7, N'Đặng Văn G', 5),
       (8, N'Lý Thị H', 6),
       (9, N'Trần Thanh I', 6),
       (10, N'Hoàng Thị K', 6);
       
-- Thêm dữ liệu mẫu vào bảng Diem
INSERT INTO Diem (MaHS, MaMon, Diem)
VALUES (1, 1, 8.5),
       (1, 2, 9.0),
       (1, 3, 8.0),
       (2, 1, 7.5),
       (2, 2, 8.0),
       (2, 3, 7.5),
       (3, 2, 9.5),
       (3, 3, 7.0),
       (3, 4, 8.5),
       (4, 1, 6.5),
       (4, 3, 8.5),
       (4, 4, 9.0),
       (5, 2, 7.0),
       (5, 4, 6.5),
       (5, 5, 7.5),
       (6, 1, 9.0),
       (6, 5, 8.5),
       (7, 2, 8.0),
       (7, 3, 8.5),
       (7, 5, 7.0),
       (8, 4, 7.5),
       (8, 5, 9.0),
       (9, 3, 8.5),
       (9, 5, 8.0),
       (10, 1, 8.0),
       (10, 2, 7.5),
       (10, 4, 9.0),
       (10, 5, 8.5);

-- 1. Các table này cho vào các schema tùy mong muốn của mọi người
   create schema data;
   create schema info;
   
   alter schema data transfer dbo.Diem;
   alter schema data transfer dbo.LopHoc;
   alter schema data transfer dbo.MonHoc;
   alter schema info transfer dbo.HocSinh;

-- 2. Viết thêm 1 cột vào bảng HocSinh là cột Tuoi kiểu dữ liệu là date
  alter table info.HocSinh add Tuoi date;
-- 3. Viết một câu lệnh thêm dữ liệu vào bảng Diem, sau đó thực hiện xóa dữ liệu vừa mới thêm vào
  select * from info.HocSinh
  insert into data.Diem 
  values(1, 4, 1.5)

  delete data.Diem
  where MaHS = 1 and MaMon = 4

-- 4. Cập nhật dữ liệu của HocSinh có MaHS là 3 thành điểm 10 ở tất cả các môn
   update data.Diem 
   set Diem =10
   where MaHS = 3

-- 5. Thực hiện đổi kiểu dữ liệu của cột Diem trong bảng Diem từ Float sang Decimal
    alter table Diem
    alter COLUMN Diem decimal(10, 2);
-- 6. Liệt kê tất cả các học sinh có điểm số cao nhất trong mỗi môn học

   select max(diem) as diem 
   from info.HocSinh as hs,data.Diem as d
   where hs.MaHS = d.MaHS
   group by d.MaMon

-- 7. Liệt kê tất cả các học sinh có điểm số trên 8 trong môn học "Toán".
   select hs.TenHS,d.MaMon,Diem
   from info.HocSinh as hs
   inner join data.Diem as d on hs.MaHS = d.MaHS
   inner join data.MonHoc as mh on mh.MaMon = d.MaMon
   where mh.TenMon = 'Toán'
   and d.Diem > 8

-- 8. Liệt kê tên và số lượng học sinh trong mỗi lớp học.
    select lh.MaLop,lh.TenLop, count(*) as soluong
    from data.LopHoc as lh
    inner join info.HocSinh as hs on lh.MaLop = hs.MaLop
    group by lh.MaLop,lh.TenLop
-- 9. Liệt kê tên các môn học mà không có học sinh nào đạt điểm số trên 7.
    select distinct mh.TenMon
    from data.MonHoc as mh 
    where mh.MaMon not in(
        select d.MaMon
        from data.Diem as d
        where d.Diem < 7)

-- 10. Liệt kê tên các học sinh có điểm số trên 7 ở cả môn "Toán" và môn "Văn".
     select hs.TenHS
     from info.HocSinh as hs 
     inner join data.Diem as d on d.MaHS = hs.MaHS
     inner join data.MonHoc as mh on mh.MaMon=d.MaMon
     where d.Diem > 7 and mh.TenMon = N'Văn'
     and hs.MaHS in (
        select hs.TenHS
        from info.HocSinh as hs 
        inner join data.MonHoc as mh on mh.MaMon=d.MaMon
        inner join data.Diem as d on d.MaHS = hs.MaHS
        where d.Diem > 7 and mh.TenMon = N'Toán'
     )
-- 11. Liệt kê tên các học sinh có điểm số cao nhất trong môn "Toán" và điểm số thấp nhất trong môn "Văn".
     select top 1 hs.TenHS
     from info.HocSinh as hs 
     inner join data.Diem as d on d.MaHS = hs.MaHS
     inner join data.MonHoc as mh on mh.MaMon=d.MaMon
     where mh.TenMon = N'Văn'
     order by d.Diem ASC
     
     select top 1 hs.TenHS
     from info.HocSinh as hs
     inner join data.Diem as d on hs.MaHS = d.MaHS
     inner join data.MonHoc as mh on mh.MaMon = d.MaMon
     where mh.TenMon = N'Toán'
     order by d.Diem DESC
-- 12. Liệt kê tên và tổng điểm của các học sinh trong mỗi lớp học, sắp xếp theo tổng điểm giảm dần.
    select hs.MaLop,lh.TenLop,sum(d.Diem) as tong_diem
    from data.Diem as d,info.HocSinh as hs,data.LopHoc as lh
    where d.MaHS = hs.MaHS 
    and hs.MaLop = lh.MaLop
    group by hs.MaLop,lh.TenLop
    order by sum(d.Diem) DESC

-- 13. Liệt kê tên và tổng điểm của các học sinh trong mỗi lớp học, chỉ lấy những lớp có tổng điểm trên 50.
    select hs.MaLop,lh.TenLop,sum(d.Diem) as tong_diem
    from data.Diem as d,info.HocSinh as hs,data.LopHoc as lh
    where d.MaHS = hs.MaHS 
    and hs.MaLop = lh.MaLop
    group by hs.MaLop,lh.TenLop
    having sum(d.Diem) > 50
-- 14. Liệt kê tên các học sinh có điểm số cao nhất trong môn "Toán" và thuộc lớp học "12A".
   select hs.TenHS
     from info.HocSinh as hs
     inner join data.Diem as d on hs.MaHS = d.MaHS
     inner join data.MonHoc as mh on mh.MaMon = d.MaMon
     inner join data.LopHoc as lh on hs.MaLop = lh.MaLop
     where mh.TenMon = N'Toán'
     and lh.TenLop = '12A'
     order by d.Diem DESC
     
-- 15. Liệt kê tên các học sinh có điểm số trên 8 trong môn "Toán" và thuộc lớp học có điểm số cao nhất trong môn "Văn".
   select hs.TenHS,d.Diem
    from info.HocSinh as hs 
    inner join data.Diem as d on d.MaHS = hs.MaHS
    inner join data.MonHoc as mh on mh.MaMon=d.MaMon
    inner join data.LopHoc as lh on lh.MaLop = hs.MaLop
    where mh.TenMon = N'Toán'
    and d.Diem > 8
    and lh.MaLop in (
        select top 1 lh.MaLop 
     from info.HocSinh as hs 
     inner join data.Diem as d on d.MaHS = hs.MaHS
     inner join data.MonHoc as mh on mh.MaMon=d.MaMon
     inner join data.LopHoc as lh on lh.MaLop = hs.MaLop
     where mh.TenMon = N'Văn'
     order by d.Diem DESC
    )

-- 16. Liệt kê tên các môn học và số lượng học sinh đạt điểm số cao nhất trong mỗi môn, và số lượng học sinh đạt điểm số trên 8 không vượt quá 5.
    select mh.TenMon 
    from data.MonHoc as mh
-- 17. Tạo một stored procedure để thêm một học sinh mới vào bảng HocSinh và tự động cập nhật tổng điểm của lớp học tương ứng.

-- 18. Viết một function để tính tổng điểm của một học sinh dựa trên điểm số từ bảng Diem.
  create function tongdiem (@mahs int)
  returns float as
  begin
      declare @tongdiem float 
      select @tongdiem = sum(diem)
      from  data.Diem as d
      where d.MaHS = @mahs
      group by d.MaHS
      return @tongdiem
  end

  print dbo.tongdiem(1)

   select * from data.MonHoc 
   select * from data.Diem   
   select * from data.LopHoc
   select * from info.HocSinh
-- 19. Sử dụng nested query để lấy danh sách các học sinh có điểm số cao nhất trong từng môn học.

-- 20. Sử dụng GROUP BY và HAVING để lấy danh sách các lớp học có số lượng học sinh trên 10 và tổng điểm của lớp học đó trên 200.
    select hs.MaLop,lh.TenLop
    from data.Diem as d
    inner join info.HocSinh as hs on hs.MaHS = d.MaHS
    inner join data.LopHoc as lh on d.MaHS = hs.MaHS
    group by hs.MaLop,lh.TenLop
    having sum(d.Diem) > 200 and count(distinct hs.MaLop) > 10
-- 21. Sử dụng stored procedure để lấy danh sách các học sinh có điểm số trên 8 trong môn học "Toán" và thuộc lớp học "12A".
   create procedure ds_hoc_sinh_21 
  as 
  begin
      select hs.TenHS
      from info.HocSinh as hs
      inner join data.LopHoc as lh on hs.MaLop = lh.MaLop
      inner join data.Diem as d on hs.MaHS = d.MaHS
      inner join data.MonHoc as mh on d.MaMon = mh.MaMon
      where mh.TenMon = 'Toán' and d.Diem > 8
      and lh.TenLop = '12A'
  end 
   

  exec ds_hoc_sinh_21
-- 22. Sử dụng trigger để tự động cập nhật điểm số trung bình của môn học sau khi có điểm mới được thêm vào bảng Diem, chỉ cập nhật cho các môn học có ít nhất 5 học sinh.
  CREATE TRIGGER uppdate_avg 
  ON data.Diem
  FOR INSERT AS 
  Begin 
    
  end
-- 23. Sử dụng stored procedure để lấy danh sách các học sinh có điểm số trên 8 trong môn "Toán" và thuộc lớp học có số lượng học sinh ít hơn 5.
   create procedure ds_hoc_sinh_23 
  as 
  begin
      select hs.TenHS
      from info.HocSinh as hs
      inner join data.LopHoc as lh on hs.MaLop = lh.MaLop
      inner join data.Diem as d on hs.MaHS = d.MaHS
      inner join data.MonHoc as mh on d.MaMon = mh.MaMon
      where mh.TenMon = 'Toán' and d.Diem > 8
      and lh.MaLop in (
        select lh.MaLop
        from data.LopHoc as lh
        inner join info.HocSinh as hs on hs.MaLop = lh.MaLop
        group by lh.MaLop
        having count(*) < 5
      )
  end 
  
  exec ds_hoc_sinh_23 
-- 24. Sử dụng transaction để bảo đảm tính toàn vẹn dữ liệu khi thực hiện một stored procedure sử dụng vòng lặp while để cập nhật thông tin của nhiều bảng cùng một lúc.

-- 25. Viết một stored procedure sử dụng vòng lặp while để kiểm tra và xóa các học sinh không có điểm số trong bảng Diem và cập nhật tổng điểm của lớp học tương ứng, trong một transaction để đảm bảo tính toàn vẹn dữ liệu.

-- 26. Liệt kê tên và xếp loại của các học sinh trong mỗi lớp học, dựa trên điểm số trung bình của họ. Xếp loại được xác định như sau:
--     - Điểm trung bình từ 9 trở lên: Xếp loại "Xuất sắc".
--     - Điểm trung bình từ 8 đến dưới 9: Xếp loại "Giỏi".
--     - Điểm trung bình từ 6.5 đến dưới 8: Xếp loại "Khá".
--     - Điểm trung bình dưới 6.5: Xếp loại "Trung bình".
     
    select hs.TenHS, lh.TenLop,
    case
        when AVG(D.Diem) >= 9 then N'Xuất sắc'
        when AVG(D.Diem) >= 8 then N'Giỏi'
        when AVG(D.Diem) >= 6.5 then N'Khá'
        else 'Trung bình'
    end as XepLoai
    from info.HocSinh hs
    inner join data.LopHoc as lh on hs.MaLop = lh.MaLop
    inner join data.Diem as d on hs.MaHS = d.MaHS
    group by hs.TenHS, lh.TenLop 
    order by lh.TenLop

-- 27. Liệt kê tên và tổng điểm của các học sinh, với điểm số mỗi môn được tính dựa trên trọng số của môn đó. Trọng số được xác định như sau:
--     - Môn "Toán": Trọng số 4.
--     - Môn "Văn": Trọng số 3.
--     - Các môn khác: Trọng số 2.

with temp as (
select hs.TenHS, lh.TenLop,
    case
        when mh.TenMon = 'Toán' then d.Diem * 4  
        when mh.TenMon = 'Văn' then d.Diem * 3
        else d.Diem * 2
    end as diem_he_so
from info.HocSinh hs
inner join data.LopHoc as lh on hs.MaLop = lh.MaLop
inner join data.Diem as d on hs.MaHS = d.MaHS
inner join data.MonHoc as mh on d.MaMon = mh.MaMon
)
select TenHS, TenLop, sum(diem_he_so) as tongdiem
from temp 
group by TenHS, TenLop 

-- 28. Tạo một role có tên "QuanLyLop" và cấp quyền SELECT, INSERT, UPDATE, DELETE trên bảng LopHoc cho role này. Sau đó, tạo một user có tên "NhanVien" và gán role "QuanLyLop" cho user này.
create role QuanLyLop;
 grant SELECT, INSERT, UPDATE, DELETE on info.LopHoc to QuanLyLop;
 use master
 create login NhanVien 
 with password = '1111'
 alter role quanLyLop add member NhanVien;
 

 -- 30. Liệt kê tên lớp học và số lượng học sinh có tổng điểm trên 30, sắp xếp theo số lượng học sinh giảm dần. Chú ý sử dụng group by, having và cte
with TotalDiem as (
    select lh.MaLop, count(distinct hs.MaHS) as SoLuongHocSinh
    from data.LopHoc as lh
    inner join info.HocSinh hs on lh.MaLop = hs.MaLop
    inner join data.Diem d on hs.MaHS = d.MaHS
    group by lh.MaLop
    having sum(D.Diem) > 30
)
select lh.TenLop, td.SoLuongHocSinh
from data.LopHoc as lh
inner join TotalDiem td on lh.MaLop = td.MaLop
order by td.SoLuongHocSinh DESC;
