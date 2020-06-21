{%- set gd_functions = cook_c_signatures("""
// GDAPI: 1.0
void godot_plane_new_with_reals(godot_plane* r_dest, godot_real p_a, godot_real p_b, godot_real p_c, godot_real p_d)
void godot_plane_new_with_vectors(godot_plane* r_dest, godot_vector3* p_v1, godot_vector3* p_v2, godot_vector3* p_v3)
void godot_plane_new_with_normal(godot_plane* r_dest, godot_vector3* p_normal, godot_real p_d)
godot_string godot_plane_as_string(godot_plane* p_self)
godot_plane godot_plane_normalized(godot_plane* p_self)
godot_vector3 godot_plane_center(godot_plane* p_self)
godot_vector3 godot_plane_get_any_point(godot_plane* p_self)
godot_bool godot_plane_is_point_over(godot_plane* p_self, godot_vector3* p_point)
godot_real godot_plane_distance_to(godot_plane* p_self, godot_vector3* p_point)
godot_bool godot_plane_has_point(godot_plane* p_self, godot_vector3* p_point, godot_real p_epsilon)
godot_vector3 godot_plane_project(godot_plane* p_self, godot_vector3* p_point)
godot_bool godot_plane_intersect_3(godot_plane* p_self, godot_vector3* r_dest, godot_plane* p_b, godot_plane* p_c)
godot_bool godot_plane_intersects_ray(godot_plane* p_self, godot_vector3* r_dest, godot_vector3* p_from, godot_vector3* p_dir)
godot_bool godot_plane_intersects_segment(godot_plane* p_self, godot_vector3* r_dest, godot_vector3* p_begin, godot_vector3* p_end)
godot_plane godot_plane_operator_neg(godot_plane* p_self)
godot_bool godot_plane_operator_equal(godot_plane* p_self, godot_plane* p_b)
void godot_plane_set_normal(godot_plane* p_self, godot_vector3* p_normal)
godot_vector3 godot_plane_get_normal(godot_plane* p_self)
godot_real godot_plane_get_d(godot_plane* p_self)
void godot_plane_set_d(godot_plane* p_self, godot_real p_d)
// GDAPI: 1.1
// GDAPI: 1.2
""") -%}

{%- block pxd_header %}
{% endblock -%}
{%- block pyx_header %}
{% endblock -%}


@cython.final
cdef class Plane:
{% block cdef_attributes %}
    cdef godot_plane _gd_data
{% endblock %}

{% block python_defs %}

    def __init__(self, godot_real a, godot_real b, godot_real c, godot_real d):
        if gdapi10 == NULL:
            return
        gdapi10.godot_plane_new_with_reals(&self._gd_data, a, b, c, d)

    @staticmethod
    def from_vectors(Vector3 v1 not None, Vector3 v2 not None, Vector3 v3 not None):
        cdef Plane ret = Plane.__new__(Plane)
        gdapi10.godot_plane_new_with_vectors(&ret._gd_data, &v1._gd_data, &v2._gd_data, &v3._gd_data)
        return ret

    @staticmethod
    def from_normal(Vector3 normal not None, godot_real d):
        cdef Plane ret = Plane.__new__(Plane)
        gdapi10.godot_plane_new_with_normal(&ret._gd_data, &normal._gd_data, d)
        return ret

    def __repr__(Plane self):
        return f"<Plane({self.as_string()})>"

    {{ render_operator_eq() | indent }}
    {{ render_operator_ne() | indent }}

    {{ render_method("__neg__", "godot_plane", gdname="operator_neg") | indent }}

    def __pos__(Plane self):
        return self

    {{ render_property("normal", "godot_vector3", "get_normal", "set_normal") | indent }}
    {{ render_property("d", "godot_real", "get_d", "set_d") | indent }}

    {{ render_method(**gd_functions["as_string"]) | indent }}
    {{ render_method(**gd_functions["normalized"]) | indent }}
    {{ render_method(**gd_functions["center"]) | indent }}
    {{ render_method(**gd_functions["get_any_point"]) | indent }}
    {{ render_method(**gd_functions["is_point_over"]) | indent }}
    {{ render_method(**gd_functions["distance_to"]) | indent }}
    {{ render_method(**gd_functions["has_point"]) | indent }}
    {{ render_method(**gd_functions["project"]) | indent }}

    def intersects_segment(Plane self, Vector3 begin not None, Vector3 end not None):
        cdef Vector3 ret = Vector3.__new__(Vector3)
        if gdapi10.godot_plane_intersects_segment(&self._gd_data, &ret._gd_data, &begin._gd_data, &end._gd_data):
            return ret
        else:
            return None

    def intersects_ray(Plane self, Vector3 from_ not None, Vector3 dir not None):
        cdef Vector3 ret = Vector3.__new__(Vector3)
        if gdapi10.godot_plane_intersects_ray(&self._gd_data, &ret._gd_data, &from_._gd_data, &dir._gd_data):
            return ret
        else:
            return None

    def intersect_3(Plane self, Plane b not None, Plane c not None):
        cdef Vector3 ret = Vector3.__new__(Vector3)
        if gdapi10.godot_plane_intersect_3(&self._gd_data, &ret._gd_data, &b._gd_data, &c._gd_data):
            return ret
        else:
            return None

    {{ render_method(**gd_functions["set_normal"]) | indent }}
    {{ render_method(**gd_functions["get_normal"]) | indent }}
    {{ render_method(**gd_functions["get_d"]) | indent }}
    {{ render_method(**gd_functions["set_d"]) | indent }}
{% endblock %}

{%- block python_consts %}
    PLANE_YZ = Plane(1, 0, 0, 0)
    PLANE_XZ = Plane(0, 1, 0, 0)
    PLANE_XY = Plane(0, 0, 1, 0)
{% endblock %}
