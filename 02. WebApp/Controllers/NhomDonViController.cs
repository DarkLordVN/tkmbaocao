using TKM.BLL;
using TKM.DAO.EntityFramework;
using TKM.Services;
using TKM.Utils;
using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TKM.WebApp.Controllers
{
    public class NhomDonViController : BaseController
    {
        private NhomDonViService _nhomDonViService;
        private DmDonViService _dmDonViService;
        #region Constructor
        public NhomDonViController()
        {
            if (_nhomDonViService == null) _nhomDonViService = new NhomDonViService();
            if (_dmDonViService == null) _dmDonViService = new DmDonViService();
        }
        #endregion
        public ActionResult Index(string tenNhom, int? trangThai, int? phongBanId, int? pnum, int? psize)
        {
            var viewModel = new NhomDonViListView();
            //SubString input text seach
            if (!String.IsNullOrEmpty(tenNhom) && tenNhom.Trim().Length > 250)
            {
                tenNhom = tenNhom.Substring(0, 250);
            }
            viewModel.PageNumber = pnum ?? 1;
            viewModel.PageSize = psize ?? 10;
            viewModel.TenNhom = tenNhom;

            //Gọi đến View
            return View(viewModel);
        }
        public ActionResult IndexDetail(NhomDonViListView viewModel)
        {
            //if (TempData.ContainsKey("AlertType") && TempData.ContainsKey("AlertData"))
            //{
            //    TempData["AlertType"] = TempData["AlertType"].ToString();
            //    TempData["AlertData"] = TempData["AlertData"].ToString();
            //}
            if (viewModel.PageNumber == null) viewModel.PageNumber = 1;
            if (viewModel.PageSize == null) viewModel.PageSize = 20;
            if (!string.IsNullOrEmpty(viewModel.TuKhoa))
            {
                viewModel.TuKhoa = viewModel.TuKhoa.Trim();
            }

            if (!string.IsNullOrEmpty(viewModel.TenNhom))
            {
                viewModel.TenNhom = viewModel.TenNhom.Trim();
            }
            bool? srTrangThai = null;
            if (viewModel.srTrangThai.HasValue)
            {
                if (viewModel.srTrangThai == 1)
                    srTrangThai = true;
                else
                    srTrangThai = false;
            }
            viewModel.TrangThai = srTrangThai;

            int total = 0;
            var lstResult = _nhomDonViService.GetList(viewModel.TuKhoa, viewModel.TenNhom, viewModel.TrangThai, viewModel.PageNumber.Value, viewModel.PageSize.Value, ref total, viewModel.ColumnName, viewModel.OrderBy);
            viewModel.LstNhomDonVi = lstResult;
            viewModel.TotalItem = total;

            if (viewModel.PageNumber > 0 && viewModel.PageSize > 0)
            {
                int[] totals = new int[total];
                ViewBag.PagedList = totals.ToPagedList((int)viewModel.PageNumber, (int)viewModel.PageSize);
            }
            return PartialView(viewModel);
        }

        public ActionResult Add()
        {
            TempData["AlertData"] = null;
            NhomDonViViewModel viewModel = new NhomDonViViewModel();
            viewModel.TrangThai = true;
            ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
            return View(viewModel);
        }

        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult Add(NhomDonViViewModel viewModel)
        {
            try
            {
                //Chọn đơn vị nhóm 
                var strDonViID = Request["ListDonViThuocNhomID"];
                if (!ModelState.IsValid)
                {
                    viewModel.ListDonViThuocNhomID = ","+strDonViID+",";
                    ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
                    return View(viewModel);
                }
                var message = validateNhomDonVi(viewModel);
                
                if (string.IsNullOrEmpty(strDonViID))
                {
                    message += "Bạn chưa chọn đơn vị </br>";
                }
                if (string.IsNullOrEmpty(message))
                {
                    if (!string.IsNullOrEmpty(viewModel.TenNhom))
                        viewModel.TenNhom = viewModel.TenNhom.Trim();

                    viewModel.TrangThai = viewModel.TrangThai;
                    viewModel.NgayTao = DateTime.Now;
                    viewModel.NguoiTaoID = SessionInfo.CurrentUser.ID;
                    viewModel.NguoiTao = SessionInfo.CurrentUser.TenDangNhap;
                    viewModel.ListDonViThuocNhomID = "," + strDonViID + ",";
                    var check = _nhomDonViService.Add(viewModel);
                    if (check)
                    {
                        TempData["AlertType"] = "alert-success";
                        TempData["AlertData"] = "Thêm mới nhóm đơn vị thành công";
                        return RedirectToAction("Index", "NhomDonVi", null);
                    }
                    message = "Thêm mới không thành công";
                }
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = message;
                ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
                return View(viewModel);
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = ex.Message;
                ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
                return View(viewModel);
            }
        }

        private string GenMaNhomDonVi()
        {
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var stringChars = new char[8];
            var random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            var finalString = new String(stringChars);
            return finalString;
        }


        public ActionResult Update(int? id)
        {
            TempData["AlertData"] = null;
            ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();

            if (id.HasValue && id.Value > 0)
            {
                NhomDonViViewModel viewModel = _nhomDonViService.GetById(id.Value);
                return View(viewModel);
            }
            return RedirectToAction("Index", "NhomDonVi", null);
        }

        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult Update(NhomDonViViewModel viewModel)
        {
            try
            {
                var strDonViID = Request["ListDonViThuocNhomID"];
                var message = String.Empty;
                if (!ModelState.IsValid)
                {
                    viewModel.ListDonViThuocNhomID = ","+strDonViID+",";
                    message = "Cập nhật không thành công";
                }
                else
                {
                    message = validateNhomDonVi(viewModel);
                    //Chọn đơn vị nhóm 
                    if (string.IsNullOrEmpty(strDonViID))
                    {
                        message += "Bạn chưa chọn đơn vị </br>";
                    }
                    if (string.IsNullOrEmpty(message))
                    {
                        var oViewModel = _nhomDonViService.GetById(viewModel.ID);
                        if (!string.IsNullOrEmpty(viewModel.TenNhom))
                            oViewModel.TenNhom = viewModel.TenNhom.Trim();
                        oViewModel.ListDonViThuocNhomID = "," + strDonViID + ",";
                        oViewModel.TrangThai = viewModel.TrangThai;
                        oViewModel.NguoiCapNhatID = SessionInfo.CurrentUser.ID;
                        oViewModel.NguoiCapNhat = SessionInfo.CurrentUser.TenDangNhap;
                        oViewModel.NgayCapNhat = DateTime.Now;
                        var check = _nhomDonViService.Update(oViewModel);
                        if (check)
                        {
                            TempData["AlertType"] = "alert-success";
                            TempData["AlertData"] = "Cập nhật nhóm đơn vị thành công";
                            return RedirectToAction("Index", "NhomDonVi", null);
                        }
                        message = "Cập nhật không thành công";
                    }
                }
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = message;
                ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
                return View(viewModel);
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = ex.Message;
                ViewBag.lstDonVi = _dmDonViService.GetList(x => x.TrangThai).ToList();
                return View(viewModel);
            }
        }
        [HttpGet]
        public ViewResult Detail(int id = 0)
        {
            var obj = new NhomDonViViewModel();
            obj = _nhomDonViService.GetById(id);
            var ds = "";
            var ten = "";
            var arrDonViID = obj.ListDonViThuocNhomID.Split(',');
            for (int i = 0; i < arrDonViID.Length; i++)
            {
                if (!string.IsNullOrEmpty(arrDonViID[i]))
                {
                    var intID = Convert.ToInt32(arrDonViID[i]);
                    ten = _dmDonViService.GetByFilter(g => g.ID == intID).TenDonVi;
                    ds += "<span><i class='fa fa-circle fs8 pr4'></i>" + (!string.IsNullOrEmpty(ten) ? ten : "") + "</span></br>";
                }
            }
            obj.DonViTrongNhom = ds;
            return View("~/Views/NhomDonVi/Detail.cshtml", obj);
        }
        [HttpPost]
        public JsonResult onChangeStatus(int? id)
        {
            bool isSuccess = false;
            var message = "";
            if (id == null)
            {
                message = "Id không được để trống";
                return Json(new { isSuccess = isSuccess, message = message }, JsonRequestBehavior.AllowGet);
            }
            var obj = _nhomDonViService.GetById(id ?? 0);
            if (obj == null)
            {
                message = "Bản ghi đã bị xóa";
                return Json(new { isSuccess = isSuccess, message = message }, JsonRequestBehavior.AllowGet);
            }
            try
            {
                obj.TrangThai = !obj.TrangThai;
                isSuccess = _nhomDonViService.Update(obj);
                message = isSuccess ? "Thay đổi trạng thái thành công" : "Đã có lỗi xảy ra";
            }
            catch (Exception)
            {
                isSuccess = false;
                message = "Đã có lỗi xảy ra";
                return Json(new { isSuccess = isSuccess, message = message }, JsonRequestBehavior.AllowGet);
            }
            return Json(new { isSuccess = isSuccess, message = message }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult Delete(int id)
        {
            // 1: xóa thành công || -1: Có lỗi xảy ra khi xóa
            var isSuccess = -1;
            try
            {
                var checkDel = _nhomDonViService.Delete(id);
                if (checkDel)
                    isSuccess = 1;
            }
            catch (Exception)
            {
                isSuccess = -1;
            }
            return Json(new { isSuccess = isSuccess }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult DeleteMul(string lstid)
        {
            bool isSuccess = false;
            var arrid = lstid.Split(',');
            try
            {
                foreach (var item in arrid)
                {
                    _nhomDonViService.Delete(Convert.ToInt32(item));
                }
                isSuccess = true;
                return Json(new
                {
                    isSuccess = isSuccess,
                }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                isSuccess = false;
                return Json(new
                {
                    isSuccess = isSuccess,
                }, JsonRequestBehavior.AllowGet);
            }

        }
        private string validateNhomDonVi(NhomDonViViewModel viewModel)
        {
            return String.Empty;
        }


    }
}