using System;
using System.Linq;
using System.Collections.Generic; 
using System.Data;
using TKM.Utils;
using System.Linq.Expressions;
using System.Transactions;
// This file is auto generated and will be overwritten as soon as the template is executed
// Do not modify this file...
	
namespace TKM.DAO.EntityFramework
{   
	public partial class NhatKyHeThongRepository
	{
		private IRepository<NhatKyHeThong> _repository {get;set;}
		public IRepository<NhatKyHeThong> Repository
		{
			get { return _repository; }
			set { _repository = value; }
		}
		
		public NhatKyHeThongRepository(IRepository<NhatKyHeThong> repository, IUnitOfWork unitOfWork)
    	{
    		Repository = repository;
			Repository.UnitOfWork = new EFUnitOfWork(); 
    	}

		public List<NhatKyHeThong> GetList(Expression<Func<NhatKyHeThong, bool>> where)
        {
            try
            {
                IEnumerable<NhatKyHeThong> lResult;
                if (where != null)
                {
                    lResult = Repository.GetMany(where);
                }
                else
                {
                    lResult = Repository.GetAll();
                }
                return lResult.ToList();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

		public List<NhatKyHeThong> GetList(Expression<Func<NhatKyHeThong, bool>> where, int pageIndex, int pageSize, ref int totalItem, Func<NhatKyHeThong, object> orderCol = null, bool isDecending = true)
        {
            try
            {
                IEnumerable<NhatKyHeThong> lResult;
                if (where != null)
                {
                    lResult = Repository.GetMany(where);
                }
                else
                {
                    lResult = Repository.GetAll();
                }
                if (orderCol != null)
                {
                    if (!isDecending) lResult = lResult.OrderBy(orderCol).AsEnumerable();
                    else lResult = lResult.OrderByDescending(orderCol).AsEnumerable();
                }
                if (pageIndex > 0 && pageSize > 0)
                {
                    totalItem = lResult.Count();
                    if (totalItem > ((pageIndex - 1) * pageSize))
                        lResult = lResult.Skip((pageIndex - 1) * pageSize).Take(pageSize);
                }
                return lResult.ToList();
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return null;
            }
        }

		public NhatKyHeThong GetById(int id)
        {
            try
            {
                var obj = Repository.GetById(id);
                return obj;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return new NhatKyHeThong();
            }
        }
        public NhatKyHeThong GetByFilter(Expression<Func<NhatKyHeThong, bool>> where)
        {
            try
            {
                Repository.Save();
                var obj = Repository.GetByFilter(where);
                return obj;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return new NhatKyHeThong();
            }
        }
		public bool CheckByFilter(Expression<Func<NhatKyHeThong, bool>> where)
        {
            try
            {
                Repository.Save();
                var obj = Repository.GetByFilter(where);
				if(obj != null) return true;
                return false;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }
        public bool Add(NhatKyHeThong entity)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    Repository.Add(entity);
                    Repository.Save();
                    scope.Complete();
                    scope.Dispose();
                    return true;
                }
                catch (Exception ex)
                {
                    scope.Dispose();
                    OutputLog.WriteOutputLog(ex);
                    return false;
                }
            }
        }
		
		public bool Add(List<NhatKyHeThong> lentity)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
					if(lentity != null && lentity.Count() > 0) {
						foreach(var entity in lentity) {
							Repository.Add(entity);
							Repository.UnitOfWork.Commit();
						}
					}
                    scope.Complete();
                    scope.Dispose();
                    return true;
                }
                catch (Exception ex)
                {
                    scope.Dispose();
                    OutputLog.WriteOutputLog(ex);
                    return false;
                }
            }
        }

        public bool Update(NhatKyHeThong entity)
        {
            try
            {
                var objOld = GetById(entity.ID);
                if (objOld.ID > 0)
                {
                    ObjectUtils.CopyObject(entity, ref objOld, true);
                    Repository.Update(objOld);
					Repository.UnitOfWork.Commit();
                }
                return true;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }

		public bool Update(List<NhatKyHeThong> lentity)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
					if(lentity != null && lentity.Count() > 0) {
						foreach(var entity in lentity) {
							var objOld = GetById(entity.ID);
							if (objOld.ID > 0)
							{
								ObjectUtils.CopyObject(entity, ref objOld, true);
								Repository.Update(objOld);
								Repository.UnitOfWork.Commit();
							}
						}
					}
                    scope.Complete();
                    scope.Dispose();
                    return true;
                }
                catch (Exception ex)
                {
                    scope.Dispose();
                    OutputLog.WriteOutputLog(ex);
                    return false;
                }
            }
        }

        public bool Delete(int id)
        {
            try
            {
                var objOld = GetById(id);
                Repository.Delete(objOld);
				Repository.UnitOfWork.Commit();
                return true;
            }
            catch (Exception ex)
            {
                OutputLog.WriteOutputLog(ex);
                return false;
            }
        }
        public bool DeleteList(List<int> ListId)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    var objOld = Repository.GetMany(x => ListId.Contains(x.ID)).ToList();
                    if (objOld != null && objOld.Count > 0)
                    {
                        foreach (var obj in objOld)
                        {
                            Repository.Delete(obj);
                            Repository.UnitOfWork.Commit();
                        }
                    }
                    scope.Complete();
                    scope.Dispose();
                    return true;
                }
                catch (Exception ex)
                {
                    scope.Dispose();
                    OutputLog.WriteOutputLog(ex);
                    return false;
                }
            }
        }
	}
}