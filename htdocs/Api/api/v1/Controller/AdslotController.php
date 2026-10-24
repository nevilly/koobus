<?php

include_once __DIR__."/../Module/AdslotModule.php";

class AdslotController extends AdslotModule
{
    public function __construct()
    {
        parent::__construct();
    }

 


    ////Mwananch ASSiament

     /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_displayRate($id = '',$limit = ''){
        $sql = parent::get_displayRate($id,$limit);
        $data = false;

        if($sql->num_rows > 0)
            if(!empty($id))
                $data = $sql->fetch_object();
            else
                $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    }
      /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_displayRate_by_pid($id = '',$limit = ''){
        $sql = parent::get_displayRate_by_pid($id,$limit);
        $data = false;

        if($sql->num_rows > 0)
            if(!empty($id))
                $data = $sql->fetch_object();
            else
                $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    } 


       /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_sponser_content($id = '',$limit = ''){
        $sql = parent::get_sponser_content($id,$limit);
        $data = false;

        if($sql->num_rows > 0)
            if(!empty($id))
                $data = $sql->fetch_object();
            else
                $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    }

       /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_social_medias($id = '',$limit = ''){
        $sql = parent::get_social_medias($id,$limit);
        $data = false;

        if($sql->num_rows > 0)
            if(!empty($id))
                $data = $sql->fetch_object();
            else
                $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    }       /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_vedeo_production($id = '',$limit = ''){
        $sql = parent::get_vedeo_production($id,$limit);
        $data = false;

        if($sql->num_rows > 0)
            if(!empty($id))
                $data = $sql->fetch_object();
            else
                $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    }




    /**
     * @param string $id
     * @param string $category
     * @param bool $not
     * @param string $limit
     * @return array
     */
    public function get_news($brand = '',$category =''){
        
        $sql = parent::get_newz($brand,$category);
        $data = false;

        if($sql->num_rows > 0)
            $data = $sql->fetch_all(MYSQLI_ASSOC);

        return $data;
    }

}