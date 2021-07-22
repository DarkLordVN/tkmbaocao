using TKM.BLL;
using TKM.DAO;
using TKM.DAO.EntityFramework;
using TKM.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace TKM.Services
{
    public class NhomDonViService
    {
        private EFUnitOfWork oUnitOfWork = new EFUnitOfWork();
        private readonly NhomDonViRepository _nhomDonViResp;
        public NhomDonViService()
        {
            _nhomDonViResp = new NhomDonViRepository(new EFRepository<NhomDonVi>(), oUnitOfWork);
        }
        public List<NhomDonViViewModel> GetList(string tuKhoa, string tenNhom, bool? trangThai, int pageIndex, int pageSize, ref int totalItem, string columnName, string orderBy)
        {
            try
            {
                Expression<Func<NhomDonVi, bool>> where;
                where = x => x.IsDeleted == false
                   && (!string.IsNullOrEmpty(tuKhoa) ? x.TenNhom.ToLower().Trim().Contains(tuKhoa.ToLower().Trim()) : true)
               && (!string.IsNullOrEmpty(tenNhom) ? x.TenNhom.ToLower().Trim().Contains(tenNhom.ToLower().Trim()) : true)
               && (trangThai != null ? x.TrangThai == trangThai : true);

                var leReturn = _nhomDonViResp.GetList(where, pageIndex, pageSize, ref totalItem,
                     //Filter theo column
                     x => (string.IsNullOrEmpty(columnName) ? (x.NgayCapNhat.HasValue ? x.NgayCapNhat.Value.ToString("yyyyMMddHHmmss") : x.NgayTao.Value.ToString("yyyyMMddHHmmss")) :
                         columnName.Equals("TenNhom") ? x.TenNhom : (x.NgayCapNhat.HasValue ? x.NgayCapNhat.Value.ToString("yyyyMMddHHmmss") : x.NgayTao.Value.ToString("yyyyMMddHHmmss"))),
                     //Order by
                     orderBy == null || (!string.IsNullOrEmpty(orderBy) && orderBy.Equals("desc")) ? true : false);
                return leReturn.ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

        public List<NhomDonViViewModel> GetList(Expression<Func<NhomDonVi, bool>> where)
        {
            try
            {
                var leReturn = _nhomDonViResp.GetList(where);
                return leReturn.ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

        public List<NhomDonViViewModel> GetListAll(int pageIndex, int pageSize, ref int totalItem)
        {
            try
            {
                Expression<Func<NhomDonVi, bool>> where = x => x.IsDeleted == false;
                var leReturn = _nhomDonViResp.GetList(where, 0, 0, ref totalItem);
                return leReturn.ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

        public List<NhomDonViViewModel> GetDdlList(int id = 0)
        {
            try
            {
                Expression<Func<NhomDonVi, bool>> where = x =>
                    x.IsDeleted == false && x.TrangThai && x.ID != id;
                int totalItem = 0;
                var leReturn = _nhomDonViResp.GetList(where, 0, 0, ref totalItem);
                return leReturn.Cast<NhomDonVi>().ToList().ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

        public NhomDonViViewModel GetById(int id)
        {
            try
            {
                var eReturn = _nhomDonViResp.GetById(id);
                return eReturn.ToModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public bool Update(NhomDonViViewModel model)
        {
            try
            {
                var entity = model.ToEntity();
                return _nhomDonViResp.Update(entity);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

        public bool Add(NhomDonViViewModel model)
        {
            try
            {
                var entity = model.ToEntity();
                return _nhomDonViResp.Add(entity);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

        public bool DeleteList(List<int> listId)
        {
            try
            {
                return _nhomDonViResp.DeleteList(listId);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }
        public bool Delete(int id)
        {
            try
            {
                return _nhomDonViResp.Delete(id);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }
    }
}
