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
    public class DmDonViService
    {
        private EFUnitOfWork oUnitOfWork = new EFUnitOfWork();
        private readonly DmDonViRepository _dmDonViResp;
        public DmDonViService()
        {
            _dmDonViResp = new DmDonViRepository(new EFRepository<DmDonVi>(), oUnitOfWork);
        }
        public List<DmDonViViewModel> GetDdlList(int currDonViId, int khoaChaId = 0)
        {
            try
            {
                Expression<Func<DmDonVi, bool>> where = x =>
                    (x.IsDeleted == false && x.TrangThai
                    && ((khoaChaId > 0) ? x.KhoaChaID == khoaChaId : true));
                int totalItem = 0;
                var leResult = _dmDonViResp.GetList(where, 0, 0, ref totalItem);
                var leReturn = leResult.ToListModel();
                var lstAll = leReturn.Cast<object>().ToList();
                var lstBuild = new List<object>();
                if (leResult != null)
                {
                    TKM.Utils.ObjectUtils.BuildHierachy(khoaChaId, lstAll, ref lstBuild, "ID", "KhoaChaID", "TenDonVi", string.Empty, false, null, "--", 0, false, currDonViId);
                    return lstBuild.Cast<DmDonViViewModel>().ToList();
                }
                return null;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public List<DmDonViViewModel> GetDdlList(Expression<Func<DmDonVi, bool>> where, int currDonViId = 0, int khoaChaId = 0)
        {
            try
            {
                //Expression<Func<DmDonVi, bool>> where = x =>
                //    (x.IsDeleted == false
                //    && ((khoaChaId > 0) ? x.KhoaChaID == khoaChaId : true));
                int totalItem = 0;
                var leResult = _dmDonViResp.GetList(where, 0, 0, ref totalItem);
                var leReturn = leResult.ToListModel();
                var lstAll = leReturn.Cast<object>().ToList();
                var lstBuild = new List<object>();
                if (leResult != null)
                {
                    TKM.Utils.ObjectUtils.BuildHierachy(khoaChaId, lstAll, ref lstBuild, "ID", "KhoaChaID", "TenDonVi", string.Empty, false, null, "--", 0, false, currDonViId);
                }
                var lstNew = lstBuild.Cast<DmDonViViewModel>().ToList();
                lstNew.AddRange(leReturn.Except(lstNew));
                return lstNew;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

        public List<DmDonViDetailListView> GetList(string tuKhoa, string maDinhDanh, string kyHieu, string tenDonVi, bool? trangThai, int pageIndex, int pageSize, ref int totalItem, string columnName, string orderBy)
        {
            try
            {
                var lvmReturn = new List<DmDonViDetailListView>();
                //Expression<Func<DmDonVi, bool>> where = x => x.IsDeleted == false && 
                //    (string.IsNullOrEmpty(kyHieu) ? true : x.KyHieu.ToLower().Trim().Contains(kyHieu.Trim().ToLower().Trim()))
                //    && (string.IsNullOrEmpty(tenDonVi) ? true : x.TenDonVi.ToLower().Trim().Contains(tenDonVi.Trim().ToLower().Trim()))
                //    && (trangThai != null ? x.TrangThai == trangThai : x.IsDeleted == false);

                var lstData = _dmDonViResp.GetList(g => g.IsDeleted == false).OrderBy(g => g.ID).ToList();
                var lstDataFull = _dmDonViResp.GetList(g => g.IsDeleted == false).OrderBy(g => g.ID);
                //Nếu tìm kiếm thì mặc định danh sách phân cấp cha con

                if (!string.IsNullOrEmpty(tuKhoa))
                {
                    lstData = lstData.Where(g => (!string.IsNullOrEmpty(g.MaDinhDanh) && g.MaDinhDanh.Trim().ToLower().Contains(tuKhoa.ToLower().Trim()))
                    || (!string.IsNullOrEmpty(g.TenDonVi) && g.TenDonVi.Trim().ToLower().Contains(tuKhoa.ToLower().Trim()))
                    || (!string.IsNullOrEmpty(g.KyHieu) && g.KyHieu.Trim().ToLower().Contains(tuKhoa.ToLower().Trim()))).ToList();
                }
                if (!string.IsNullOrEmpty(maDinhDanh))
                {
                    lstData = lstData.Where(g => !string.IsNullOrEmpty(g.MaDinhDanh) && g.MaDinhDanh.Trim().ToLower().Contains(maDinhDanh.ToLower().Trim())).ToList();
                }
                if (!string.IsNullOrEmpty(tenDonVi))
                {
                    lstData = lstData.Where(g => !string.IsNullOrEmpty(g.TenDonVi) && g.TenDonVi.Trim().ToLower().Contains(tenDonVi.ToLower().Trim())).ToList();
                }
                if (!string.IsNullOrEmpty(kyHieu))
                {
                    lstData = lstData.Where(g => !string.IsNullOrEmpty(g.KyHieu) && g.KyHieu.Trim().ToLower().Contains(kyHieu.ToLower().Trim())).ToList();
                }
                if (trangThai != null)
                {
                    lstData = lstData.Where(g => g.TrangThai == trangThai).ToList();
                }

                ////DataSearch
                //var lstIDByDataKey = lstData.Select(g => g.ID).ToArray();
                //var lstFinalID = new List<int>();
                //foreach (var itemID in lstIDByDataKey)
                //{
                //    lstFinalID.AddRange(CommonUtils.GetAllParent(lstDataFull.ToList(), itemID));
                //}
                //lstData = _entities.Database.SqlQuery<DmDonVi>("Select * from DmDonVi where ID IN (" + String.Join(",", lstFinalID) + ")").ToList();
                //Nếu tìm kiếm thì không phân cấp cha con nữa
                if (!string.IsNullOrEmpty(tenDonVi) || !string.IsNullOrEmpty(maDinhDanh) || !string.IsNullOrEmpty(kyHieu) || !string.IsNullOrEmpty(tuKhoa) || trangThai != null)
                {

                }
                else
                    lstData = CommonUtils.CreateLevel(lstData);
                Func<DmDonVi, object> orderCol = x => (string.IsNullOrEmpty(columnName) ? (x.NgayCapNhat.HasValue ? x.NgayCapNhat.Value.ToString("yyyyMMddHHmmss") : x.NgayTao.Value.ToString("yyyyMMddHHmmss")) :
                         columnName.Equals("KyHieu") ? x.KyHieu :
                         columnName.Equals("MaDinhDanh") ? x.MaDinhDanh :
                         columnName.Equals("TenDonVi") ? x.TenDonVi : (x.NgayCapNhat.HasValue ? x.NgayCapNhat.Value.ToString("yyyyMMddHHmmss") : x.NgayTao.Value.ToString("yyyyMMddHHmmss")));
                var isDecending = !string.IsNullOrEmpty(orderBy) && orderBy.Equals("desc") ? true : false;
                if (lstData != null)
                {
                    if (columnName != null)
                    {
                        if (!isDecending) lstData = lstData.OrderBy(orderCol).ToList();
                        else lstData = lstData.OrderByDescending(orderCol).ToList();
                    }
                    //var leResult = _dmDonViService.GetList(where, pageIndex, pageSize, ref totalItem,//Filter theo column
                    //     x => (string.IsNullOrEmpty(columnName) ? null :
                    //         columnName.Equals("KyHieu") ? x.KyHieu :
                    //         columnName.Equals("TenDonVi") ? x.TenDonVi : null),
                    //     //Order by
                    //     );
                    totalItem = lstData.Count();
                    lstData = lstData.Skip((pageIndex - 1) * pageSize).Take(pageSize).ToList();
                    foreach (var entity in lstData)
                    {
                        var vm = new DmDonViDetailListView();
                        vm.KyHieu = entity.KyHieu;
                        vm.MaDinhDanh = entity.MaDinhDanh;
                        vm.ID = entity.ID;
                        vm.TenDonVi = entity.TenDonVi;
                        vm.TrangThai = entity.TrangThai;
                        lvmReturn.Add(vm);
                    }
                }
                return lvmReturn;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public List<DmDonViViewModel> GetList(Expression<Func<DmDonVi, bool>> where)
        {
            try
            {
                var leReturn = _dmDonViResp.GetList(where);
                if (leReturn != null)
                    return leReturn.ToListModel();
                return null;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public List<DmDonVi> GetListMaDinhDanh(string maDinhDanh, int id = 0)
        {
            try
            {
                if (string.IsNullOrEmpty(maDinhDanh))
                {
                    return null;
                }
                var lst = new List<DmDonVi>();
                if (id == 0)
                    lst = _dmDonViResp.GetList(x => x.IsDeleted == false && !string.IsNullOrEmpty(x.MaDinhDanh) && x.MaDinhDanh.ToLower().Trim().Contains(maDinhDanh.ToLower().Trim())).ToList();
                else
                    lst = _dmDonViResp.GetList(x => x.IsDeleted == false && x.ID != id && !string.IsNullOrEmpty(x.MaDinhDanh) && x.MaDinhDanh.ToLower().Trim().Contains(maDinhDanh.ToLower().Trim())).ToList();
                return lst;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public List<DmDonViViewModel> GetListTopOne(int pageIndex, int pageSize, ref int totalItem, string columnName, string orderBy)
        {
            try
            {
                Expression<Func<DmDonVi, bool>> where = x => x.IsDeleted == false;

                var leReturn = _dmDonViResp.GetList(where, pageIndex, pageSize, ref totalItem,
                     //Filter theo column
                     x => x.ID);
                return leReturn.ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }

        }
        public DmDonViViewModel GetByFilter(Expression<Func<DmDonVi, bool>> where)
        {
            try
            {
                var leReturn = _dmDonViResp.GetByFilter(where);
                if (leReturn != null)
                    return leReturn.ToModel();
                return null;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public List<DmDonViViewModel> GetListByFilter(Expression<Func<DmDonVi, bool>> where)
        {
            try
            {
                return null;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public int GetMaxThuTu()
        {
            try
            {
                return _dmDonViResp.GetList(x => x.TrangThai).Select(x => x.ThuTu).Max() ?? 0;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return 0;
            }
        }
        public bool GetCheckTrungThuTu(int so, int id = 0)
        {
            try
            {
                return _dmDonViResp.CheckByFilter(x => (id > 0 ? x.ID == id : true) && x.ThuTu == so);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

        public DmDonViViewModel GetById(int id)
        {
            try
            {
                var eReturn = _dmDonViResp.GetById(id);
                if (eReturn != null)
                    return eReturn.ToModel();
                return null;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
        public bool Update(DmDonViViewModel model)
        {
            try
            {
                var entity = model.ToEntity();
                return _dmDonViResp.Update(entity);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

        public bool Add(DmDonViViewModel model)
        {
            try
            {
                var entity = model.ToEntity();
                return _dmDonViResp.Add(entity);
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
                return _dmDonViResp.DeleteList(listId);
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
                return _dmDonViResp.Delete(id);
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

        public List<DmDonViViewModel> LoadCbDmDonVi()
        {
            try
            {
                int totalItem = 0;
                Expression<Func<DmDonVi, bool>> where = x => x.TrangThai;
                var leResult = _dmDonViResp.GetList(where, 0, 0, ref totalItem);
                return leResult.Cast<DmDonVi>().ToList().ToListModel();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }
    }
}
