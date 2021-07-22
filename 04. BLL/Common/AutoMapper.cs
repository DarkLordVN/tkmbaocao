using TKM.DAO.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace TKM.BLL
{
    public static class AutoMapper
    {
        private static MapperConfiguration _mapperConfiguration;
        private static IMapper _mapper;

        #region Constructor
        public static IMapper Mapper
        {
            get
            {
                if (_mapper == null)
                    Init();
                return _mapper;
            }
        }
        public static MapperConfiguration MapperConfiguration
        {
            get
            {
                return _mapperConfiguration;
            }
        }

        //Map extension
        public static TDestination MapTo<TSource, TDestination>(this TSource source)
        {
            return AutoMapper.Mapper.Map<TSource, TDestination>(source);
        }

        public static TDestination MapTo<TSource, TDestination>(this TSource source, TDestination destination)
        {
            return Mapper.Map(source, destination);
        }
        #endregion

        public static void Init()
        {
            _mapperConfiguration = new MapperConfiguration(cfg =>
            {
                //Quyen
                cfg.CreateMap<Quyen, QuyenViewModel>();
                cfg.CreateMap<QuyenViewModel, Quyen>();
                //NguoiDung
                cfg.CreateMap<NguoiDung, NguoiDungViewModel>();
                cfg.CreateMap<NguoiDungViewModel, NguoiDung>();
                //NhatKyHeThong
                cfg.CreateMap<NhatKyHeThong, NhatKyHeThongViewModel>();
                cfg.CreateMap<NhatKyHeThongViewModel, NhatKyHeThong>();
                //DmDonVi
                cfg.CreateMap<DmDonVi, DmDonViViewModel>();
                cfg.CreateMap<DmDonViViewModel, DmDonVi>();
                //NhomQuyen
                cfg.CreateMap<NhomQuyen, NhomQuyenViewModel>();
                cfg.CreateMap<NhomQuyenViewModel, NhomQuyen>();
                //NhomNguoiDung
                cfg.CreateMap<NhomNguoiDung, NhomNguoiDungViewModel>();
                cfg.CreateMap<NhomNguoiDungViewModel, NhomNguoiDung>();
                //NhomDonVi
                cfg.CreateMap<NhomDonVi, NhomDonViViewModel>();
                cfg.CreateMap<NhomDonViViewModel, NhomDonVi>();
                //LichLanhDao
                cfg.CreateMap<ThongBao, ThongBaoViewModel>();
                cfg.CreateMap<ThongBaoViewModel, ThongBao>();
                //HeThongThamSo
                cfg.CreateMap<HeThongThamSo, HeThongThamSoViewModel>();
                cfg.CreateMap<HeThongThamSoViewModel, HeThongThamSo>();
            });
            _mapper = _mapperConfiguration.CreateMapper();
        }

        #region QuyenEntity

        public static QuyenViewModel ToModel(this Quyen entity)
        {
            return entity.MapTo<Quyen, QuyenViewModel>();
        }

        public static Quyen ToEntity(this QuyenViewModel model)
        {
            return model.MapTo<QuyenViewModel, Quyen>();
        }

        public static List<QuyenViewModel> ToListModel(this List<Quyen> lEntity)
        {
            var lModel = new List<QuyenViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<Quyen, QuyenViewModel>());
                }
            }
            return lModel;
        }

        public static List<Quyen> ToListEntity(this List<QuyenViewModel> lModel)
        {
            var lEntity = new List<Quyen>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<QuyenViewModel, Quyen>());
                }
            }
            return lEntity;
        }
        #endregion

        #region NguoiDungEntity

        public static NguoiDungViewModel ToModel(this NguoiDung entity)
        {
            var vm = entity.MapTo<NguoiDung, NguoiDungViewModel>();
            return vm;
        }

        public static NguoiDung ToEntity(this NguoiDungViewModel model)
        {
            var entity = model.MapTo<NguoiDungViewModel, NguoiDung>();
            if (string.IsNullOrEmpty(entity.MatKhau)) entity.MatKhau = "123123";
            return entity;
        }


        public static List<NguoiDungViewModel> ToListModel(this List<NguoiDung> lEntity)
        {
            var lModel = new List<NguoiDungViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.ToModel());
                }
            }
            return lModel;
        }

        public static List<NguoiDung> ToListEntity(this List<NguoiDungViewModel> lModel)
        {
            var lEntity = new List<NguoiDung>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<NguoiDungViewModel, NguoiDung>());
                }
            }
            return lEntity;
        }
        #endregion

        #region NhatKyHeThongEntity

        public static NhatKyHeThongViewModel ToModel(this NhatKyHeThong entity)
        {
            var item = entity.MapTo<NhatKyHeThong, NhatKyHeThongViewModel>();
            //item.TenNguoiDung = entity.NguoiDung != null ? entity.NguoiDung.HoVaTen : "";
            return item;
        }

        public static NhatKyHeThong ToEntity(this NhatKyHeThongViewModel model)
        {
            return model.MapTo<NhatKyHeThongViewModel, NhatKyHeThong>();
        }

        public static List<NhatKyHeThongViewModel> ToListModel(this List<NhatKyHeThong> lEntity)
        {
            var lModel = new List<NhatKyHeThongViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    var item = entity.MapTo<NhatKyHeThong, NhatKyHeThongViewModel>();
                    //item.TenNguoiDung = entity.NguoiDung != null ? entity.NguoiDung.HoVaTen : "";
                    lModel.Add(item);
                }
            }
            return lModel;
        }

        public static List<NhatKyHeThong> ToListEntity(this List<NhatKyHeThongViewModel> lModel)
        {
            var lEntity = new List<NhatKyHeThong>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<NhatKyHeThongViewModel, NhatKyHeThong>());
                }
            }
            return lEntity;
        }
        #endregion

        #region DmDonViEntity

        public static DmDonViViewModel ToModel(this DmDonVi entity)
        {
            var item = entity.MapTo<DmDonVi, DmDonViViewModel>();
            item.TenVaKyHieu = entity.TenDonVi + (!string.IsNullOrEmpty(entity.KyHieu) ? " (" + entity.KyHieu + ")" : "");
            return item;
        }

        public static DmDonVi ToEntity(this DmDonViViewModel model)
        {
            return model.MapTo<DmDonViViewModel, DmDonVi>();
        }


        public static List<DmDonViViewModel> ToListModel(this List<DmDonVi> lEntity)
        {
            var lModel = new List<DmDonViViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    var item = entity.MapTo<DmDonVi, DmDonViViewModel>();
                    item.TenVaKyHieu = entity.TenDonVi + (!string.IsNullOrEmpty(entity.KyHieu) ? " (" + entity.KyHieu + ")" : "");
                    lModel.Add(item);
                }
            }
            return lModel;
        }

        public static List<DmDonVi> ToListEntity(this List<DmDonViViewModel> lModel)
        {
            var lEntity = new List<DmDonVi>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<DmDonViViewModel, DmDonVi>());
                }
            }
            return lEntity;
        }

        //Thêm Mapper detail
        public static DmDonViDetailListView ToModelDetail(this DmDonVi entity)
        {
            return entity.MapTo<DmDonVi, DmDonViDetailListView>();
        }

        public static List<DmDonViDetailListView> ToListModelDetail(this List<DmDonVi> lEntity)
        {
            var lModel = new List<DmDonViDetailListView>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<DmDonVi, DmDonViDetailListView>());
                }
            }
            return lModel;
        }
        #endregion

        #region NhomQuyenEntity

        public static NhomQuyenViewModel ToModel(this NhomQuyen entity)
        {
            return entity.MapTo<NhomQuyen, NhomQuyenViewModel>();
        }

        public static NhomQuyen ToEntity(this NhomQuyenViewModel model)
        {
            return model.MapTo<NhomQuyenViewModel, NhomQuyen>();
        }

        public static List<NhomQuyenViewModel> ToListModel(this List<NhomQuyen> lEntity)
        {
            var lModel = new List<NhomQuyenViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<NhomQuyen, NhomQuyenViewModel>());
                }
            }
            return lModel;
        }

        public static List<NhomQuyen> ToListEntity(this List<NhomQuyenViewModel> lModel)
        {
            var lEntity = new List<NhomQuyen>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<NhomQuyenViewModel, NhomQuyen>());
                }
            }
            return lEntity;
        }
        #endregion
      
        #region NhomNguoiDungEntity

        public static NhomNguoiDungViewModel ToModel(this NhomNguoiDung entity)
        {
            return entity.MapTo<NhomNguoiDung, NhomNguoiDungViewModel>();
        }

        public static NhomNguoiDung ToEntity(this NhomNguoiDungViewModel model)
        {
            return model.MapTo<NhomNguoiDungViewModel, NhomNguoiDung>();
        }

        public static List<NhomNguoiDungViewModel> ToListModel(this List<NhomNguoiDung> lEntity)
        {
            var lModel = new List<NhomNguoiDungViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<NhomNguoiDung, NhomNguoiDungViewModel>());
                }
            }
            return lModel;
        }

        public static List<NhomNguoiDung> ToListEntity(this List<NhomNguoiDungViewModel> lModel)
        {
            var lEntity = new List<NhomNguoiDung>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<NhomNguoiDungViewModel, NhomNguoiDung>());
                }
            }
            return lEntity;
        }
        #endregion

        #region NhomDonViEntity

        public static NhomDonViViewModel ToModel(this NhomDonVi entity)
        {
            return entity.MapTo<NhomDonVi, NhomDonViViewModel>();
        }

        public static NhomDonVi ToEntity(this NhomDonViViewModel model)
        {
            return model.MapTo<NhomDonViViewModel, NhomDonVi>();
        }

        public static List<NhomDonViViewModel> ToListModel(this List<NhomDonVi> lEntity)
        {
            var lModel = new List<NhomDonViViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<NhomDonVi, NhomDonViViewModel>());
                }
            }
            return lModel;
        }

        public static List<NhomDonVi> ToListEntity(this List<NhomDonViViewModel> lModel)
        {
            var lEntity = new List<NhomDonVi>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<NhomDonViViewModel, NhomDonVi>());
                }
            }
            return lEntity;
        }
        #endregion
        
        #region HeThongThamSoEntity

        public static HeThongThamSoViewModel ToModel(this HeThongThamSo entity)
        {
            return entity.MapTo<HeThongThamSo, HeThongThamSoViewModel>();
        }

        public static HeThongThamSo ToEntity(this HeThongThamSoViewModel model)
        {
            return model.MapTo<HeThongThamSoViewModel, HeThongThamSo>();
        }

        public static List<HeThongThamSoViewModel> ToListModel(this List<HeThongThamSo> lEntity)
        {
            var lModel = new List<HeThongThamSoViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<HeThongThamSo, HeThongThamSoViewModel>());
                }
            }
            return lModel;
        }

        public static List<HeThongThamSo> ToListEntity(this List<HeThongThamSoViewModel> lModel)
        {
            var lEntity = new List<HeThongThamSo>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<HeThongThamSoViewModel, HeThongThamSo>());
                }
            }
            return lEntity;
        }
        #endregion
        
        #region ThongBaoEntity

        public static ThongBaoViewModel ToModel(this ThongBao entity)
        {
            var item = entity.MapTo<ThongBao, ThongBaoViewModel>();
            item.ChucNang = item.ChucNangID != 0 && item.ChucNangID != null ? TKM.Utils.ObjectUtils.GetDescription((TKM.Utils.Enums.LoaiLienKetVanBan)item.ChucNangID) : "Thông báo";
            return item;
        }

        public static ThongBao ToEntity(this ThongBaoViewModel model)
        {
            return model.MapTo<ThongBaoViewModel, ThongBao>();
        }

        public static List<ThongBaoViewModel> ToListModel(this List<ThongBao> lEntity)
        {
            var lModel = new List<ThongBaoViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    var item = entity.MapTo<ThongBao, ThongBaoViewModel>();
                    item.ChucNang = item.ChucNangID != 0 && item.ChucNangID != null ? TKM.Utils.ObjectUtils.GetDescription((TKM.Utils.Enums.ChucNang)item.ChucNangID) : "Thông báo";
                    lModel.Add(item);
                }
            }
            return lModel;
        }

        public static List<ThongBao> ToListEntity(this List<ThongBaoViewModel> lModel)
        {
            var lEntity = new List<ThongBao>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<ThongBaoViewModel, ThongBao>());
                }
            }
            return lEntity;
        }
        #endregion

        #region ThongBaoAttachEntity

        public static ThongBaoAttachViewModel ToModel(this ThongBaoAttach entity)
        {
            return entity.MapTo<ThongBaoAttach, ThongBaoAttachViewModel>();
        }

        public static ThongBaoAttach ToEntity(this ThongBaoAttachViewModel model)
        {
            return model.MapTo<ThongBaoAttachViewModel, ThongBaoAttach>();
        }

        public static List<ThongBaoAttachViewModel> ToListModel(this List<ThongBaoAttach> lEntity)
        {
            var lModel = new List<ThongBaoAttachViewModel>();
            if (lEntity != null && lEntity.Count > 0)
            {
                foreach (var entity in lEntity)
                {
                    lModel.Add(entity.MapTo<ThongBaoAttach, ThongBaoAttachViewModel>());
                }
            }
            return lModel;
        }

        public static List<ThongBaoAttach> ToListEntity(this List<ThongBaoAttachViewModel> lModel)
        {
            var lEntity = new List<ThongBaoAttach>();
            if (lModel != null && lModel.Count > 0)
            {
                foreach (var model in lModel)
                {
                    lEntity.Add(model.MapTo<ThongBaoAttachViewModel, ThongBaoAttach>());
                }
            }
            return lEntity;
        }
        #endregion
    }
}