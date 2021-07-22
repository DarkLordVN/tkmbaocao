using TKM.BLL;
using TKM.Services;
using PagedList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Text.RegularExpressions;
using TKM.Utils;
using TKM.DAO.EntityFramework;

namespace TKM.WebApp.Controllers
{
    public class DmDonViController : BaseController
    {
        private DmDonViService _dmDonViService;
        private NguoiDungService _nguoiDungService;
        #region Constructor
        public DmDonViController()
        {
            if (_dmDonViService == null) _dmDonViService = new DmDonViService();
            if (_nguoiDungService == null) _nguoiDungService = new NguoiDungService();
        }
        #endregion
        /// GET: DonVi
        /// <summary>
        /// </summary>
        /// <param name="isSuccess">Check cờ: Show và set hiển thị thông báo sau khi xóa thành công</param>
        /// <param name="tenDonVi">Filter: Tên đơn vị</param>
        /// <param name="dmDonViId">Filter: Phòng ban</param>
        /// <param name="pnum">Index trang hiện tại</param>
        /// <param name="psize">Số lượng bản ghi hiển thị</param>
        /// <returns></returns>
        public ActionResult Index(string maDinhDanh, string kyHieu, string tenDonVi, int? trangThai, int? pnum, int? psize)
        {

            //SubString input text seach
            if (!String.IsNullOrEmpty(maDinhDanh) && maDinhDanh.Trim().Length > 50)
            {
                maDinhDanh = maDinhDanh.Substring(0, 50);
            }
            if (!String.IsNullOrEmpty(kyHieu) && kyHieu.Trim().Length > 50)
            {
                kyHieu = kyHieu.Substring(0, 50);
            }
            if (!String.IsNullOrEmpty(tenDonVi) && tenDonVi.Trim().Length > 250)
            {
                tenDonVi = tenDonVi.Substring(0, 250);
            }

            //Tạo constructor view model
            var viewModel = new DmDonViListView()
            {
                PageNumber = pnum ?? 1,
                PageSize = psize ?? 10
            };

            //Save lại filter truyền vào
            viewModel.MaDinhDanh = maDinhDanh;
            viewModel.KyHieu = kyHieu;
            viewModel.TenDonVi = tenDonVi;
            //Gọi đến View
            return View(viewModel);
        }
        public ActionResult IndexDetail(DmDonViListView viewModel)
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

            if (!string.IsNullOrEmpty(viewModel.TenDonVi))
            {
                viewModel.TenDonVi = viewModel.TenDonVi.Trim();
            }
            if (!string.IsNullOrEmpty(viewModel.MaDinhDanh))
            {
                viewModel.MaDinhDanh = viewModel.MaDinhDanh.Trim();
            }
            if (!string.IsNullOrEmpty(viewModel.KyHieu))
            {
                viewModel.KyHieu = viewModel.KyHieu.Trim();
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
            var lstResult = _dmDonViService.GetList(viewModel.TuKhoa, viewModel.MaDinhDanh, viewModel.KyHieu, viewModel.TenDonVi, viewModel.TrangThai, viewModel.PageNumber.Value, viewModel.PageSize.Value, ref total, viewModel.ColumnName, viewModel.OrderBy);

            viewModel.LstDonVi = lstResult;
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
            DmDonViViewModel viewModel = new DmDonViViewModel();
            //viewModel.CbDonVi = loadDonVi();
            ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(x => x.TrangThai).ToList());
            viewModel.ThuTu = _dmDonViService.GetMaxThuTu() + 1;
            viewModel.ThuTus = viewModel.ThuTu.ToString();
            ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == SessionInfo.CurrentUser.DonViID);
            viewModel.TrangThai = true;
            return View(viewModel);
        }

        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult Add(DmDonViViewModel viewModel)
        {
            try
            {
                var message = String.Empty;
                //Check validate ở ViewModel
                
                if (!ModelState.IsValid)
                {
                    message += "Thêm mới không thành công!</br>";
                }
                else
                {
                    if (viewModel.KhoaChaID == null) viewModel.KhoaChaID = 0;
                    viewModel.TrangThai = viewModel.TrangThai;
                    //Check validate ở Controller
                    message = validateDonVi(viewModel);
                    
                    //var ListCanBoXuLyVanBanDenID = Request["ListCanBoXuLyVanBanDenID"];
                    //var ListCanBoXuLyHoSoCongViecID = Request["ListCanBoXuLyHoSoCongViecID"];
                    //viewModel.ListCanBoXuLyVanBanDenID = ListCanBoXuLyVanBanDenID;
                    //viewModel.ListCanBoXuLyHoSoCongViecID = ListCanBoXuLyHoSoCongViecID;
                    //if (string.IsNullOrEmpty(ListCanBoXuLyVanBanDenID))
                    //    message += "Bạn chưa chọn cán bộ xử lý văn bản đến </br>";
                    //if (string.IsNullOrEmpty(ListCanBoXuLyHoSoCongViecID))
                    //    message += "Bạn chưa chọn cán bộ xử lý hồ sơ công việc </br>";
                    if (string.IsNullOrEmpty(message))
                    {
                        if (!string.IsNullOrEmpty(viewModel.TenDonVi))
                            viewModel.TenDonVi = viewModel.TenDonVi.Trim();
                        if (!string.IsNullOrEmpty(viewModel.KyHieu))
                            viewModel.KyHieu = viewModel.KyHieu.Trim();
                        if (!string.IsNullOrEmpty(viewModel.MaDinhDanh))
                            viewModel.MaDinhDanh = viewModel.MaDinhDanh.Trim();
                        //if (!string.IsNullOrEmpty(ListCanBoXuLyVanBanDenID))
                        //    viewModel.ListCanBoXuLyVanBanDenID = "," + ListCanBoXuLyVanBanDenID + ",";
                        //if (!string.IsNullOrEmpty(ListCanBoXuLyHoSoCongViecID))
                        //    viewModel.ListCanBoXuLyHoSoCongViecID = "," + ListCanBoXuLyHoSoCongViecID + ",";
                        //viewModel.MaDonVi = Utils.CommonUtils.RandomString(6);
                        viewModel.NgayTao = DateTime.Now;
                        viewModel.NguoiTaoID = SessionInfo.CurrentUser.ID;
                        viewModel.NguoiTao = SessionInfo.CurrentUser.TenDangNhap;
                        //Insert đơn vị vào db                  
                        var check = _dmDonViService.Add(viewModel);
                        if (check)
                        {
                            TempData["AlertType"] = "alert-success";
                            TempData["AlertData"] = "Thêm mới đơn vị thành công";
                            return RedirectToAction("Index", "DmDonVi", null);
                        }
                        message = "Thêm mới không thành công!";
                    }
                    else
                    {
                        TempData["AlertData"] = "Thêm mới không thành công! <br/>" + message;
                    }
                }

                //Show lỗi + Load lại data
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = message;
                //ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == SessionInfo.CurrentUser.DonViID);
                ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(x => x.TrangThai).ToList());
                return View(viewModel);
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = ex.Message;
                //ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == SessionInfo.CurrentUser.DonViID);
                ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(x => x.TrangThai).ToList());
                return View(viewModel);
            }
        }

        public ActionResult Update(int? id)
        {
            TempData["AlertData"] = null;
            if (id.HasValue && id.Value > 0)
            {
                DmDonViViewModel viewModel = _dmDonViService.GetById(id.Value);
                viewModel.ThuTus = viewModel.ThuTu.ToString();
                viewModel.ID = viewModel.ID;
                //viewModel.CbDonVi = loadDonVi();
                ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == viewModel.ID);
                ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(g => g.ID != viewModel.ID).ToList());
                return View(viewModel);
            }
            return RedirectToAction("Index", "DonVi", null);
        }

        [ValidateAntiForgeryToken]
        [HttpPost]
        public ActionResult Update(DmDonViViewModel viewModel)
        {
            try
            {
                var message = String.Empty;
               
                if (!ModelState.IsValid)
                {
                    message = "Cập nhật không thành công!";
                }
                else
                {
                    //Check validate ở Controller
                    if (viewModel.KhoaChaID == null) viewModel.KhoaChaID = 0;
                    message = validateDonVi(viewModel);
                    var ListCanBoXuLyVanBanDenID = Request["ListCanBoXuLyVanBanDenID"];
                    var ListCanBoXuLyHoSoCongViecID = Request["ListCanBoXuLyHoSoCongViecID"];
                    viewModel.ListCanBoXuLyVanBanDenID = ListCanBoXuLyVanBanDenID;
                    viewModel.ListCanBoXuLyHoSoCongViecID = ListCanBoXuLyHoSoCongViecID;
                    //if (string.IsNullOrEmpty(ListCanBoXuLyVanBanDenID))
                    //    message += "Bạn chưa chọn cán bộ xử lý văn bản đến </br>";
                    //if (string.IsNullOrEmpty(ListCanBoXuLyHoSoCongViecID))
                    //    message += "Bạn chưa chọn cán bộ xử lý hồ sơ công việc </br>";
                    if (string.IsNullOrEmpty(message))
                    {
                        var oViewModel = _dmDonViService.GetById(viewModel.ID);

                        if (!string.IsNullOrEmpty(viewModel.TenDonVi))
                            oViewModel.TenDonVi = viewModel.TenDonVi.Trim();
                        if (!string.IsNullOrEmpty(viewModel.KyHieu))
                            oViewModel.KyHieu = viewModel.KyHieu.Trim();
                        if (!string.IsNullOrEmpty(viewModel.MaDinhDanh))
                            oViewModel.MaDinhDanh = viewModel.MaDinhDanh.Trim();
                        if (!string.IsNullOrEmpty(ListCanBoXuLyVanBanDenID))
                            oViewModel.ListCanBoXuLyVanBanDenID = "," + ListCanBoXuLyVanBanDenID + ",";
                        if (!string.IsNullOrEmpty(ListCanBoXuLyHoSoCongViecID))
                            oViewModel.ListCanBoXuLyHoSoCongViecID = "," + ListCanBoXuLyHoSoCongViecID + ",";
                        oViewModel.GhiChu = viewModel.GhiChu;
                        oViewModel.KhoaChaID = viewModel.KhoaChaID;
                        oViewModel.ThuTu = viewModel.ThuTu;
                        oViewModel.TrangThai = viewModel.TrangThai;
                        oViewModel.NguoiCapNhatID = SessionInfo.CurrentUser.ID;
                        oViewModel.NguoiCapNhat = SessionInfo.CurrentUser.TenDangNhap;
                        oViewModel.NgayCapNhat = DateTime.Now;
                        oViewModel.IsDonVi = viewModel.IsDonVi;
                        //Update đơn vị vào db
                        var check = _dmDonViService.Update(oViewModel);
                        if (check)
                        {
                            TempData["AlertType"] = "alert-success";
                            TempData["AlertData"] = "Cập nhật đơn vị thành công";
                            return RedirectToAction("Index", "DmDonVi", null);
                        }
                        message = "Cập nhật không thành công!";
                    }
                    else
                    {
                        TempData["AlertData"] = "Cập nhật không thành công! <br/>" + message;
                    }
                }
                //Show lỗi 
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = message;
                ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == viewModel.ID);
                ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(x => x.TrangThai).ToList());
                return View(viewModel);
            }
            catch (Exception ex)
            {
                TempData["AlertType"] = "alert-danger";
                TempData["AlertData"] = ex.Message;
                ViewBag.lstNguoiDung = _nguoiDungService.GetList(x => x.TrangThai && x.DonViID == viewModel.ID);
                ViewBag.lstDonVi = CommonUtils.CreateLevel(_dmDonViService.GetList(x => x.TrangThai).ToList());
                return View(viewModel);
            }
        }
        [HttpGet]
        public ViewResult Detail(int id = 0)
        {
            var obj = new DmDonViViewModel();
            var lstNguoiDung = new List<NguoiDungViewModel>();
            obj = _dmDonViService.GetById(id);
            var tenDonViTrucThuoc = "";
            var strFill = "";
            if (obj.KhoaChaID != 0)
            {
                var objCha = _dmDonViService.GetByFilter(x => x.ID == obj.KhoaChaID);
                if (objCha != null)
                {
                    tenDonViTrucThuoc = objCha.TenDonVi;
                }
            }
            ViewBag.tenDonViTrucThuoc = tenDonViTrucThuoc;
            if (!string.IsNullOrEmpty(obj.ListCanBoXuLyVanBanDenID))
            {
                lstNguoiDung = _nguoiDungService.GetList(x => !string.IsNullOrEmpty(obj.ListCanBoXuLyVanBanDenID) && obj.ListCanBoXuLyVanBanDenID.Contains("," + x.ID.ToString() + ","));
                if (lstNguoiDung != null && lstNguoiDung.Count > 0)
                {
                    strFill = string.Join("</br>", lstNguoiDung.Select(x => x.ChucVuVaTen));
                }
            }
            obj.ListCanBoXuLyVanBanDen = strFill;
            strFill = "";
            lstNguoiDung = null;
            if (!string.IsNullOrEmpty(obj.ListCanBoXuLyHoSoCongViecID))
            {
                lstNguoiDung = _nguoiDungService.GetList(x => !string.IsNullOrEmpty(obj.ListCanBoXuLyHoSoCongViecID) && obj.ListCanBoXuLyHoSoCongViecID.Contains("," + x.ID.ToString() + ","));
                if (lstNguoiDung != null && lstNguoiDung.Count > 0)
                {
                    strFill = string.Join("</br>", lstNguoiDung.Select(x=>x.ChucVuVaTen));
                }
            }
            obj.ListCanBoXuLyHoSoCongViec = strFill;
            return View("~/Views/DmDonVi/Detail.cshtml", obj);
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
            var obj = _dmDonViService.GetById(id ?? 0);
            if (obj == null)
            {
                message = "Bản ghi đã bị xóa";
                return Json(new { isSuccess = isSuccess, message = message }, JsonRequestBehavior.AllowGet);
            }
            try
            {
                obj.TrangThai = !obj.TrangThai;
                isSuccess = _dmDonViService.Update(obj);
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
                var checkDel = _dmDonViService.Delete(id);
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
                    _dmDonViService.Delete(Convert.ToInt32(item));
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
        private bool checkTonTaiMaDinhDanh(DmDonViViewModel viewModel, int id = 0)
        {
            var lstCheck = _dmDonViService.GetListMaDinhDanh(viewModel.MaDinhDanh, id);
            if (lstCheck != null && lstCheck.Count() > 0)
            {
                return true;
            }
            return false;
        }
        private string validateDonVi(DmDonViViewModel viewModel)
        {
            string strError = string.Empty;
            ////Check Trùng mã
            var isTrung = checkTonTaiMaDinhDanh(viewModel, viewModel.ID);
            if (isTrung)
                strError += "Mã định danh đơn vị đã tồn tại </br>";
            //Check k nhập tiếng việt
            if (!string.IsNullOrEmpty(viewModel.MaDinhDanh))
            {

                var checkVietChar = Regex.IsMatch(viewModel.MaDinhDanh, "^[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]");
                if (checkVietChar)
                    strError += "Sai định dạng mã định danh </br>";
                if (viewModel.MaDinhDanh.Length < 13)
                {
                    strError += "Mã định danh phải chứa 13 ký tự </br>";
                }
            }

            try
            {
                if (!string.IsNullOrEmpty(viewModel.ThuTus))
                {
                    viewModel.ThuTu = int.Parse(viewModel.ThuTus);
                }
            }
            catch (Exception e)
            {
                strError += "Số thứ tự phải là số </br>";
                ModelState.AddModelError("ThuTus", "Số thứ tự phải là số");
            }
            if (viewModel.ThuTu.HasValue && viewModel.ThuTu.Value <= 0)
            {
                strError += "Số thứ tự phải lớn hơn 0 </br>";
                ModelState.AddModelError("ThuTus", "Số thứ tự phải lớn hơn 0");
            }
            //Trim input text
            if (String.IsNullOrEmpty(strError))
            {
                viewModel.TenDonVi = viewModel.TenDonVi.Trim();
                if (!string.IsNullOrEmpty(viewModel.GhiChu))
                {
                    viewModel.GhiChu = viewModel.GhiChu.Trim();
                }
            }

            return strError;
        }
        private List<DmDonViViewModel> loadDonVi()
        {
            //Lấy danh sách phòng ban
            var lvmDonVi = _dmDonViService.GetDdlList(0);
            //Thêm bản ghi vào vị trí đầu tiên (0)
            if (lvmDonVi == null) lvmDonVi = new List<DmDonViViewModel>();
            lvmDonVi.Insert(0, new DmDonViViewModel { ID = 0, TenDonVi = "--- Chọn đơn vị ---" });
            return lvmDonVi;
        }
        private List<DmDonViViewModel> loadDonVi(DmDonViViewModel viewModel)
        {
            //Lấy danh sách đơn vị
            var lvmResult = _dmDonViService.GetDdlList(viewModel.ID, 0);
            //Thêm bản ghi vào vị trí đầu tiên (0)
            if (lvmResult == null) lvmResult = new List<DmDonViViewModel>();
            lvmResult.Insert(0, new DmDonViViewModel { ID = 0, TenDonVi = "--- Không chọn ---" });
            return lvmResult;
        }
    }
}