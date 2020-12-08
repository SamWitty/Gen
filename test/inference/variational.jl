@testset "black box variational inference" begin

    Random.seed!(1)

    @gen function model()
        slope = @trace(normal(-1, exp(0.5)), :slope)
        intercept = @trace(normal(1, exp(2.0)), :intercept)
    end

    @gen function approx()
        @param slope_mu::Float64
        @param slope_log_std::Float64
        @param intercept_mu::Float64
        @param intercept_log_std::Float64
        @trace(normal(slope_mu, exp(slope_log_std)), :slope)
        @trace(normal(intercept_mu, exp(intercept_log_std)), :intercept)
    end

    # to regular black box variational inference
    init_param!(approx, :slope_mu, 0.)
    init_param!(approx, :slope_log_std, 0.)
    init_param!(approx, :intercept_mu, 0.)
    init_param!(approx, :intercept_log_std, 0.)

    observations = choicemap()
    update = ParamUpdate(GradientDescent(1, 100000), approx)
    update = ParamUpdate(GradientDescent(1., 1000), approx)
    black_box_vi!(model, (), observations, approx, (), update;
        iters=2000, samples_per_iter=100, verbose=false)
    slope_mu = get_param(approx, :slope_mu)
    slope_log_std = get_param(approx, :slope_log_std)
    intercept_mu = get_param(approx, :intercept_mu)
    intercept_log_std = get_param(approx, :intercept_log_std)
    @test isapprox(slope_mu, -1., atol=0.001)
    @test isapprox(slope_log_std, 0.5, atol=0.001)
    @test isapprox(intercept_mu, 1., atol=0.001)
    @test isapprox(intercept_log_std, 2.0, atol=0.001)

    # smoke test for black box variational inference with Monte Carlo objectives
    init_param!(approx, :slope_mu, 0.)
    init_param!(approx, :slope_log_std, 0.)
    init_param!(approx, :intercept_mu, 0.)
    init_param!(approx, :intercept_log_std, 0.)
    black_box_vimco!(model, (), observations, approx, (), update, 20;
        iters=50, samples_per_iter=100, verbose=false, geometric=false)

    init_param!(approx, :slope_mu, 0.)
    init_param!(approx, :slope_log_std, 0.)
    init_param!(approx, :intercept_mu, 0.)
    init_param!(approx, :intercept_log_std, 0.)
    black_box_vimco!(model, (), observations, approx, (), update, 20;
        iters=50, samples_per_iter=100, verbose=false, geometric=true)

end
