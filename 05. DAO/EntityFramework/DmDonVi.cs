//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TKM.DAO.EntityFramework
{
    using System;
    using System.Collections.Generic;
    
    public partial class DmDonVi
    {
        public int ID { get; set; }
        public Nullable<int> KhoaChaID { get; set; }
        public string MaDinhDanh { get; set; }
        public string TenDonVi { get; set; }
        public string KyHieu { get; set; }
        public string NguoiTao { get; set; }
        public Nullable<System.DateTime> NgayTao { get; set; }
        public Nullable<int> NguoiTaoID { get; set; }
        public Nullable<int> NguoiCapNhatID { get; set; }
        public string NguoiCapNhat { get; set; }
        public Nullable<System.DateTime> NgayCapNhat { get; set; }
        public Nullable<int> ThuTu { get; set; }
        public bool TrangThai { get; set; }
        public bool IsDeleted { get; set; }
        public Nullable<bool> IsDonVi { get; set; }
        public string ListCanBoXuLyVanBanDenID { get; set; }
        public string ListCanBoXuLyHoSoCongViecID { get; set; }
    }
}
