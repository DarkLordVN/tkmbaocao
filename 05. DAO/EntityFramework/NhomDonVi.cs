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
    
    public partial class NhomDonVi
    {
        public int ID { get; set; }
        public string TenNhom { get; set; }
        public string ListDonViThuocNhomID { get; set; }
        public string NguoiTao { get; set; }
        public Nullable<System.DateTime> NgayTao { get; set; }
        public Nullable<int> NguoiTaoID { get; set; }
        public Nullable<int> NguoiCapNhatID { get; set; }
        public string NguoiCapNhat { get; set; }
        public Nullable<System.DateTime> NgayCapNhat { get; set; }
        public bool TrangThai { get; set; }
        public bool IsDeleted { get; set; }
    }
}